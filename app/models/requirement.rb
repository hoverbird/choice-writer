class Requirement < ActiveRecord::Base
  belongs_to :fact
  belongs_to :event_response

  def to_unity_hash
    unity_hash = Hashie::Mash
    unity_hash["$type"] = "vgBlackboardFact, Assembly-CSharp"
    unity_hash["Name"] = fact.name
    unity_hash["Status"] = fact_test_value
  end
end
