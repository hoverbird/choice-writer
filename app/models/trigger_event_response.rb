class TriggerEventResponse < Response
  alias :event_to_trigger :on_finish_event_name

  def to_unity_hash
    {
      "$type" => "vgTriggerEventResponseSpecification, Assembly-CSharp",
      "EventToTrigger" => on_finish_event_name
    }
  end

  def to_web_hash
    {
      id: id,
      Type: self.class.name,
      on_finish_event_name: on_finish_event_name
    }
  end
end
