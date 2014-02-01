require 'tree'

class DialogTree

  def self.build_tree(lines)
    root_line = lines.select {|r| r.previous_line_id == nil || r.previous_line_id == ''}.first
    root = Tree::TreeNode.new(root_line.id.to_s, root_line)
    tree = append_node(root, lines)
  end

  def self.append_node(node, lines, tree = nil)
    puts "Calling with node:", node #, lines, tree
    # puts "Tree"
    tree = node unless tree

    unless tree.size == lines.size
      # puts "CONTENT", node.content
      lines.select {|line| line.previous_line_id.to_s == node.name}.each do |line|
        puts "Found a node's content", node.content.first.class
        puts "Found a line", line.class

        # puts "APPENDING", line, node
        node << Tree::TreeNode.new(line.id.to_s, line)
      end
      node.children.each {|child| append_node(child, lines, tree)}
    end
    tree
  end
end