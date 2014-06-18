class Fact < ActiveRecord::Base
  has_many :fact_mutations
  has_many :responses, through: :mutations

  has_many :requirements
  has_many :event_responses, through: :requirements

  def to_unity_hash(requirement_value)
    unity_hash = {}
    unity_hash["$type"] = "vgBlackboardFact, Assembly-CSharp"
    unity_hash["Name"] = name
    unity_hash["Status"] = requirement_value
    unity_hash
  end

  def to_web_hash
    {
      name: name,
      description: description,
      defaultStatus: default_value || 'f'
    }
  end
end
