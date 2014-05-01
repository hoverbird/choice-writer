class Requirement < ActiveRecord::Base
  belongs_to :fact
  belongs_to :event_response, dependent: :destroy

  def to_unity_hash
    {
      "$type" => "vgBlackboardFact, Assembly-CSharp",
      "Name" => fact.name,
      "Status" => fact_test_value
    }
  end

  def to_web_hash
    {id: id, FactTest: fact_test, FactTestValue: fact_test_value}.merge(fact.to_web_hash)
  end
end
