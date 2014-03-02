# encoding: UTF-8

require 'hashie'
require 'redcarpet'

class Line < Hashie::Dash
  DEFAULT_TEXT = "…"

  property :id, :required => true, :default => lambda {SecureRandom.uuid}
  property :scene, :required => true
  property :text, :default => DEFAULT_TEXT
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
    text ? MARKDOWN.render(text) : DEFAULT_TEXT
  end
end
