class EventResponse < ActiveRecord::Base
  has_many :responses
  has_many :requirements
  has_many :facts, through: :requirements

  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :folder

  #TODO: validate that a response to a given event name is unique among its number of reqs
  # event name with the requirement count to ID

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    # TODO this should be doable in a single query with AREL
    Response.where("search_vector @@ #{sanitized}").collect{|response| response.event_response}
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
    @web_hash = { id: id, EventName: name }

    if requirements.present?
      @web_hash["Requirements"] = requirements.collect {|req| req.to_web_hash}
    end

    if responses.present?
      sorted_responses = responses.sort_by {|r| r.type }.reverse
      @web_hash["Responses"] = sorted_responses.collect {|resp| resp.to_web_hash}
    end
    @web_hash
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
    @unity_id ||= "#{name}-response-{requirements.count}"
  end

  private
    def collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
