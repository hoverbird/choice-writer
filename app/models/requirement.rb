class Requirement < ActiveRecord::Base
  belongs_to :fact
  belongs_to :event_response, dependent: :destroy

  COMPARATOR_INDEX = ['='].freeze

  def to_unity_hash
    {
      "$type" => "vgBlackboardFact, Assembly-CSharp",
      "Name" => fact.name,
      "Status" => status,
      "comparator" => comparator,
      "leftValue" => left_value,
      "rightValue" => right_value
    }
  end

  def to_web_hash
    { id: id,
      comparator: COMPARATOR_INDEX[comparator.to_i],
      status: status,
      leftValue: left_value,
      rightValue: right_value }.merge(fact.to_web_hash)
  end
end
