class Choice < ActiveRecord::Base
  belongs_to :dialog_tree_response

  def to_unity_hash
    {
      "$type" => "vgDialogChoice, Assembly-CSharp",
      "DisplayText" => text,
      "EventResponse" => event_name # event that's fired when the choice is made
    }
  end
end
