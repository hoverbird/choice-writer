class DialogTreeResponse < Response
  has_many :choices

  def to_unity_hash

    choice_hash = Hash.new("$type" => "System.Collections.Generic.List`1[[vgDialogChoice, Assembly-CSharp]], mscorlib")
    choice_hash["$values"] = choices.collect {|choice| choice.to_unity_hash}

    dialog_hash = Hash.new("$type" => "vgDialogDefinition, Assembly-CSharp")
    dialog_hash["Choices"] = choice_hash

    unity_hash = Hash.new("$type" => "vgDialogTreeResponseSpecification, Assembly-CSharp")
    unity_hash["DialogToShow"] = dialog_hash

    unity_hash
  end
end
