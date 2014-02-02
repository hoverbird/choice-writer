require 'hashie'
require 'redcarpet'

class Line < Hashie::Dash
  property :id, :required => true, :default => lambda {SecureRandom.uuid}
  property :scene, :required => true
  property :text
  property :character
  property :tags
  property :previous_line_id
  property :conditions
  property :aftereffects
  property :audio_file

  MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => false, :space_after_headers => true)


  def self.create_from_row(row)
    new(row.to_hash)
  end

  def markdown_text
    MARKDOWN.render(text)
  end
end
