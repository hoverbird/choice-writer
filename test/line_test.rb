require '../models/dialog_tree'
require '../models/line'

describe "Dialog Tree" do
  let (:test_lines) do
    [
      Line.new(id: "1", previous_line_id: nil, scene: "Bar"),
      Line.new(id: "2", previous_line_id: 1, scene: "Bar"),
      Line.new(id: "3", previous_line_id: 2, scene: "Bar"),
      Line.new(id: "4", previous_line_id: 3, scene: "Bar"),
      Line.new(id: "5", previous_line_id: 4, scene: "Bar"),
      Line.new(id: "6", previous_line_id: 4, scene: "Bar"),
      Line.new(previous_line_id: 5, scene: "Bar")
    ]
  end

  it "should build into a tree" do
    tree = DialogTree.build_tree(test_lines)
    tree.print_tree
    tree.size.should == test_lines.size

  end
end