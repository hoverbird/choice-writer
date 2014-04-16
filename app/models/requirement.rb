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
    {ID: id, Name: => fact.name, Status: => fact_test_value }
  end
end
