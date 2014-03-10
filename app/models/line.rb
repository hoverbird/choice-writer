# encoding: UTF-8

require 'hashie'
require 'redcarpet'
require 'jbuilder'

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

  def to_json
    Jbuilder.encode do |json|
      json.content format_content(@message.content)
      json.(@message, :created_at, :updated_at)

      json.author do
        json.name @message.creator.name.familiar
        json.email_address @message.creator.email_address_with_name
        json.url url_for(@message.creator, format: :json)
      end

      if current_user.admin?
        json.visitors calculate_visitors(@message)
      end

      json.comments @message.comments, :content, :created_at

      json.attachments @message.attachments do |attachment|
        json.filename attachment.filename
        json.url url_for(attachment)
      end
    end
  end

end
