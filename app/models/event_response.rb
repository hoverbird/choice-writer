class EventResponse < ActiveRecord::Base
  has_many :responses, dependent: :destroy
  has_many :requirements, dependent: :destroy
  has_many :facts, through: :requirements

  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :folder

  #TODO: validate that a response to a given event name is unique among its number of reqs
  # event name with the requirement count to ID

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    # TODO this should be doable in a single query with AREL
    Response.where("search_vector @@ #{sanitized}").collect {|response| response.event_response}
  end

  def self.collection_to_unity_hash(event_response_collection)
    unity_hash = Hashie::Mash.new
    unity_hash["$type"] = "System.Collections.Generic.List`1[[vgEventResponseSpecification, Assembly-CSharp]], mscorlib"
    unity_hash["$values"] = event_response_collection.collect do |event_response|
      event_response.to_unity_hash
    end
    unity_hash
  end

  def self.collection_to_web_hash(event_response_collection)
    event_response_collection.collect {|event_response| event_response.to_web_hash }
  end

  def to_web_hash
    @web_hash = {
      id: id,
      unity_id: unity_id,
      EventName: in_response_to_event_name,
      in_response_to_event_name: in_response_to_event_name
    }

    if requirements.present?
      @web_hash[:Requirements] = requirements.collect {|req| req.to_web_hash}
    end

    if responses.present?
      # TODO: this is not the final sort order
      sorted_responses = responses.sort_by {|r| r.type }.reverse
      @web_hash[:on_finish_event_name] = on_finish_event_name
      @web_hash[:Responses] = sorted_responses.collect {|resp| resp.to_web_hash}
    end
    @web_hash.symbolize_keys!
  end

  def to_unity_hash
    @unity_hash = Hashie::Mash.new
    @unity_hash.EventName = name
    @unity_hash.DatabaseId = unity_id

    if requirements.present?
      @unity_hash.Requirements = {
        "$type" => collection_type('BlackboardFact'),
        "$values" => requirements.collect {|req| req.to_unity_hash}
      }
    end

    if responses.present?
      @unity_hash.Responses = {
        "$type" => collection_type('ResponseSpecification'),
        "$values" => responses.collect do |resp|
          resp.to_unity_hash
        end
      }
    end

    @unity_hash.SourceFilePath = folder.name if folder
    @unity_hash
  end

  def in_response_to_event_name
    name
  end

  # TODO: should we memoize this and store it on the event response? it's more expensive to look up later
  def on_finish_event_name
    @on_finish_event_name ||= responses.collect {|r| r.on_finish_event_name}.compact.first
  end

  def expand_chain
    events_before = Response.where(on_finish_event_name: self.name)

    events_after = self.responses.pluck("on_finish_event_name").compact.map do |event_name|
      EventResponse.where name: event_name
    end
    [events_before, self, events_after].flatten
  end

  # For purposes of import/export to the event system JSON files, we ID event
  # responses by the name they respond to and the number of requirments they have.
  def unity_id
    @unity_id ||= "#{in_response_to_event_name}_#{requirements.size}"
  end

  def self.bukkit_collection(collection)
    # select all in the collection that do not respond to ANYTHING fired by others in the coll
    # these are the "roots". remove them from the coll
    puts collection.size
    roots = []
    collection.reject! do |er|
      er.in_response_to_event_name.blank? ||
      should_reject = !collection.any? do |inner_er|
        inner_er.on_finish_event_name == er.in_response_to_event_name
      end
      roots.push(er) if should_reject
      should_reject
    end
    puts roots.size
    puts collection.size
    puts roots.map(&:unity_id)

    roots.each do |er|

    end
    # for each root, go through the coll and pull out where the root.on_finish_event_name matches el.in_response_to_event_name
    # for each of those
  end

 # b[1116].each {|er| pp [er[:in_response_to_event_name], er[:on_finish_event_name]].join(" ==> ")}
  def self.bouquet_collection(collection)
    buckets = []
    deep_search = lambda do |buckets, item|
      buckets.each do |array, outer_index|
        if inner_index = buckets.index(item)
          return [outer_index, inner_index]
        end
      end
      nil
    end

    collection.each do |event_response|
      puts "****" * 4
      puts "Inspecting #{event_response.id}, which responds to #{event_response.in_response_to_event_name} and triggers #{event_response.on_finish_event_name}"

      in_response_to_coll = collection.find_all do |er|
        event_response.in_response_to_event_name == er.on_finish_event_name
      end

      triggering_coll = collection.find_all do |er|
        if event_response.on_finish_event_name == er.in_response_to_event_name
          puts "#{er.id}: #{event_response.on_finish_event_name} is the same as #{er.in_response_to_event_name}!"
          true
        end
      end
      puts "!!!!"
      pp triggering_coll.map(&:to_web_hash)

      if in_response_to_coll.empty? && triggering_coll.empty?
        puts "Found no event response that triggers for us OR we trigger for. So starting a new bucket!!!!!!!!"
        buckets.push [event_response.to_web_hash]
      else
        in_response_to_coll.each do |irt_er|
          puts "Looking at what triggers us, #{irt_er.id} triggers #{irt_er.on_finish_event_name}"
          indices = deep_search.call(buckets, irt_er)
          if indices
            puts "Hoo boy, we found #{irt_er.id} in a bucket at #{indices}."
            bucket[indices.first].insert([indices.last], event_response.to_web_hash)
            puts "So we are slipping #{event_response.id} in just after it"
          else
            puts "Found no reference to #{irt_er.id} in our buckets. Starting a new bucket and putting BOTH in"
            buckets.push [irt_er.to_web_hash, event_response.to_web_hash]
          end
        end

        triggering_coll.each do |resp_er|
          puts "Looking at what WE trigger, #{resp_er.id} is triggered by #{resp_er.on_finish_event_name}"
          indices = deep_search.call(buckets, resp_er)
          if indices
            puts "Oh wow, we found #{resp_er.id} in a bucket at #{indices}."
            bucket[indices.first].insert([indices.last - 1], event_response.to_web_hash)
            puts "So we are slipping #{event_response.id} in just BEFORE it"
          else
            puts "Found no reference to #{resp_er.id} in our buckets. Starting a new bucket and putting BOTH in"
            buckets.push [resp_er.to_web_hash, event_response.to_web_hash]
          end
        end
      end
    end
    puts "DONE"
    buckets
  end


  # def self.bucket_collection(collection)
  #   buckets = {}
  #   collection.each do |event_response|
  #     puts "****"
  #     puts "Inspecting #{event_response.id}, which responds to #{event_response.in_response_to_event_name}"
  #     in_response_to = collection.find do |er|
  #       event_response.in_response_to_event_name == er.on_finish_event_name
  #     end
  #     if in_response_to
  #       puts "FOUND #{in_response_to.id} in collection, which triggers: #{in_response_to.on_finish_event_name}"
  #       # puts "#{event_response.on_finish_event_name} is in response_to #{in_response_to.on_finish_event_name}"
  #       if bucket = buckets[in_response_to.id]
  #         puts "Found a bucket which contains #{in_response_to.id}"
  #         bucket.push(event_response.to_web_hash)
  #       else
  #         puts "Starting new bucket for #{in_response_to.id}"
  #         buckets[in_response_to.id] = [
  #           in_response_to.to_web_hash,
  #           event_response.to_web_hash
  #         ]
  #       end
  #     else
  #       puts "New bucket created for TOTALLY NEW: #{event_response.on_finish_event_name}"
  #       buckets[event_response.id] = [event_response.to_web_hash]
  #     end
  #   end
  #   buckets
  # end

  private
    def collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
