class FactResponse < Response
  has_many :fact_mutations
  has_many :facts, through: fact_mutations

  def to_unity_json
    unity_hash = {}
    unity_hash["$type"] = "vgBlackboardFactResponseSpecification, Assembly-CSharp"

    mutation = fact_mutations.first

    unity_hash["FactName"] = mutation.fact.name
    unity_hash["NewStatus"] = mutation.new_value

    unity_hash
  end

  def to_web_json
    mutation = fact_mutations.first
    { "Type" => self.class.name,
      "FactName" => mutation.fact.name,
      "NewStatus" => mutation.new_value}
  end
end
