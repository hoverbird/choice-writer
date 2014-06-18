class FactResponse < Response
  has_many :fact_mutations, foreign_key: :response_id
  has_many :facts, through: :fact_mutations

  # TODO: we should return all mutations, not just the first
  def mutation
    @mutation ||= fact_mutations.first
  end

  def to_unity_hash
    unity_hash = {}
    unity_hash["$type"] = "vgBlackboardFactResponseSpecification, Assembly-CSharp"

    unity_hash["FactName"] = mutation.fact.name
    unity_hash["NewStatus"] = mutation.new_value

    unity_hash
  end

  def to_web_hash
    { id: id,
      Type: self.class.name,
      name: mutation.fact.name,
      new_status: mutation.humanized_new_status,
      default_status: mutation.fact.humanized_default_status,
      op: mutation.humanized_op }
  end
end
