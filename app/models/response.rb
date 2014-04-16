class Response < ActiveRecord::Base
  belongs_to :event_response
  belongs_to :on_finish_event, class_name: "Event", foreign_key: "on_finish_event_id"

  has_many :fact_mutations
  has_many :mutated_facts, through: :fact_mutations

  belongs_to :folder
  delegate :event_name, to: :event

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    Response.where("search_vector @@ #{sanitized}")
  end

  def self.collection_as_unity_JSON(events = :all)
    events = Event.all.to_a unless events.kind_of?(Array)
    Jbuilder.new do |json|
      json.key_format! :camelize => :upper

      json.set! "$type", collection_type("EventResponseSpecification")
      json.set! "$values", events do |event|
        json.event_name event.name
        json.set! "$type", "vgEventResponseSpecification, Assembly-CSharp"

        # Requirements
        if event.requirements.present?
          json.set! "Requirements" do
            json.set! "$type", collection_type("BlackboardFact")
            json.set! "$values" do
              json.array! event.requirements do |requirement|
                json.set! "NewStatus", requirement.fact.default_value
                json.set! "FactName", requirement.fact.name
              end
            end
          end
        end # end Requirements

        fake_response_array = ["TODO: remove this jbuilder hackery"]

        json.set! "Responses" do
          json.set! "$type", collection_type("ResponseSpecification")
          json.set! "$values" do
            json.array! event.responses do |r|
              json.set! "$type", "vgSpeechResponseSpecification, Assembly-CSharp"
              json.set! "SpeechToPlay" do
                json.set! "$type", "vgSpeechInstance, Assembly-CSharp"
                json.set! "Caption", r.clean_text

                # Always trigger a finish event, even if there is not currently another response
                json.set! "OnFinishEvent", r.on_finish_event
                json.set! "OnFinishEventDelay", r.buffer_seconds if r.buffer_seconds

                json.set! "HackAudioDuration", r.hack_audio_duration if r.hack_audio_duration
                json.set! "MinimumDuration", r.minimum_duration if r.minimum_duration
                json.set! "AllowQueueing", r.allow_queueing unless r.allow_queueing.nil?
                json.set! "AudioClipPath", r.audio_clip_path if r.audio_clip_path

              end
            end
          end
        end #end Responses

      end # end Moment
    end
  end
  # end self.collection_as_unity_JSON

  def response_type
    self.class.name
  end

  def character_slug
    character_base = self.character.present? ? self.character : 'anonymous'
    character_base.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def clean_text
    text && text.chomp
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


  private
    def self.collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
