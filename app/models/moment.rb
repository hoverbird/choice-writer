class Moment < ActiveRecord::Base
  belongs_to :folder
  belongs_to :previous_moment, class_name: "Moment", foreign_key: "previous_moment_id"
  has_many :constraints
  has_many :facts, through: :constraints
  has_many :taggings
  has_many :tags, through: :taggings

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    Moment.where("search_vector @@ #{sanitized}")
  end

  def expand_from_leaf
    this_moment = self
    moment_chain = [this_moment]
    while this_moment = this_moment.previous_moment
      moment_chain.unshift this_moment
    end
    moment_chain
  end

  def expand_from_root
    this_moment = self
    moment_chain = [this_moment]
    while this_moment = Moment.where(previous_moment: this_moment).first
      moment_chain.push this_moment
    end
    moment_chain
  end

  # TODO: this is terribly inefficient
  def next_moments
    @next_moments ||= Moment.where(previous_moment: this_moment).to_a
  end

  def as_web_JSON
    Jbuilder.new do |json|
      json.(self, :id, :created_at, :updated_at)

      json.constraints self.constraints do |constraint|
        json.fact_test constraint.fact_test
        json.fact_name constraint.fact.name
        json.fact_default_value constraint.fact.default_value
      end
    end
  end

  def self.collection_as_unity_JSON(moments = :all)
    moments = Moment.all.to_a unless moments.kind_of?(Array)
    Jbuilder.new do |json|
      json.key_format! :camelize => :upper

      json.set! "$type", collection_type("EventResponseSpecification")
      json.set! "$values", moments do |moment|
        json.set! "$type", "vgEventResponseSpecification, Assembly-CSharp"
        json.event_name "approach_rocks_closestToTower" #TODO: don't hardcode

        # Requirements
        json.set! "Requirements" do
          json.set! "$type", collection_type("BlackboardFact")
          json.set! "$values" do
            json.array! moment.constraints do |constraint|
              json.set! "NewStatus", constraint.fact.default_value
              json.set! "FactName", constraint.fact.name
            end
          end
        end # end Requirements

        json.set! "Responses" do
          json.set! "$type", collection_type("ResponseSpecification")
          json.set! "$values" do
            json.array! do
              json.set! "$type", "vgSpeechResponseSpecification, Assembly-CSharp"
              json.set! "SpeechToPlay" do
                json.set! "$type", "vgSpeechInstance, Assembly-CSharp" do
                  json.set! "Caption", moment.text

                  json.set! "HackAudioDuration", 0.0
                  json.set! "AllowQueueing", true
                  json.set! "MinimumDuration", 0.0

                  # if moment.has_audio?
                  #   json.set! "AudioClipPath", self.audio_clip_path "HiDenny.wav"
                  # end

                  if moment.nextMoments && nextMoments.size == 1
                    json.set! "OnFinishEvent", "Reply#{nextMoment.id}to#{moment.id}"
                    json.set! "OnFinishEventDelay", moment.buffer_seconds
                  end
                end
              end
            end
          end
        end #end Responses

      end # end Moment
    end
  end

  private
    def self.collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
