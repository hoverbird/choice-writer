class Response < ActiveRecord::Base
  belongs_to :event_response

  has_many :fact_mutations
  has_many :facts, through: :fact_mutations

  belongs_to :folder
  delegate :event_name, to: :event

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    Response.where("search_vector @@ #{sanitized}")
  end

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

  private
    def self.collection_type(type_string)
      "System.Collections.Generic.List`1[[vg#{type_string}, Assembly-CSharp]], mscorlib"
    end
end
