class Fact < ActiveRecord::Base

  def to_unity_hash(requirement_value)
    unity_hash = Hashie::Mash.new
    unity_hash["$type"] = "vgBlackboardFact, Assembly-CSharp"
    unity_hash["Name"] = name
    unity_hash["Status"] = requirement_value
    unity_hash
  end
end
