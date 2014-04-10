class Requirement < ActiveRecord::Base
  belongs_to :fact
  belongs_to :event_response

  def to_unity_hash
    {
      "$type" => "vgBlackboardFact, Assembly-CSharp",
      "Name" => fact.name,
      "Status" => fact_test_value
    }
  end
end
