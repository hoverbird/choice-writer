require 'tree'

class DialogTree

  def self.build_tree(lines)
    root_line = lines.select {|r| r.previous_line_id == nil || r.previous_line_id == ''}.first
    raise "No lines found in this scene" unless root_line
    root = Tree::TreeNode.new(root_line.id.to_s, root_line)
    tree = append_node(root, lines)
  end

  def self.append_node(node, lines, tree = nil)
    tree = node unless tree
    unless tree.size == lines.size
      lines.select {|line| line.previous_line_id.to_s == node.name}.each do |line|
        node << Tree::TreeNode.new(line.id.to_s, line)
      end
      node.children.each {|child| append_node(child, lines, tree)}
    end
    tree
  end

end