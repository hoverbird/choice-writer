require 'hashie'

class Line < Hashie::Dash
  property :id, :required => true
  property :scene, :required => true
  property :text
  property :character
  property :tags
  property :previous_line_id
  property :conditions
  property :after_effects

  def self.create_from_row(row)
    self.new(
      :id => row[0],
      :character => row[1],
      :text => row[2],
      :conditions => row[3],
      :after_effects => row[4],
      :scene => row[5],
      :previous_line_id => row[6],
      :previous_line_id => row[7],
      :tags => row[8]
    )
  end
end
