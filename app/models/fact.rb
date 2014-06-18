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


  def humanized_default_status
    case default_value
      when "1.0" then 't'
      else 'f'
    end
  end

  def to_web_hash
    {
      name: name,
      description: description,
      default_status: humanized_default_status
    }
  end
end
