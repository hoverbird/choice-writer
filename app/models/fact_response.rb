class FactResponse < Response
  has_many :fact_mutations
  has_many :facts, through: fact_mutations

  def to_unity_json
    unity_hash = Hashie::Mash.new
    unity_hash["$type"] = "vgBlackboardFactResponseSpecification, Assembly-CSharp"

    mutation = fact_mutations.first

    unity_hash["FactName"] = mutation.fact.name
    unity_hash["NewStatus"] = mutation.new_value

    unity_hash
  end
end
