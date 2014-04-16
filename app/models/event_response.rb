class EventResponse < ActiveRecord::Base
  has_many :responses
  has_many :requirements
  has_many :facts, through: :requirements

  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :folder

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
    @web_hash = { ID: id, EventName: name }

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

  private
    def collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
