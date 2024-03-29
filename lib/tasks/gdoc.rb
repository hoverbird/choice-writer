# encoding: UTF-8
require 'google_drive'
require 'erubis'
require 'sinatra'
require 'json'
require 'hashie'
require 'redcarpet'

# require 'active_support/all'
# require 'active_record'
#
# require './models/line'
# require './models/dialog_tree'

# db = URI.parse('postgres://hoverbird:pass@localhost/choice_writer')

# ActiveRecord::Base.establish_connection(
#   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#   :host     => db.host,
#   :username => db.user,
#   :password => db.password,
#   :database => db.path[1..-1],
#   :encoding => 'utf8'
# )


# encoding: UTF-8



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


class GDocReader

  # set :erb, :escape_html => true
                                                                                 name, sec = "patrick@camposanto.com", "c4mp3s1n0"
  # You can also use OAuth. See document of
  # GoogleDrive.login_with_oauth for details.
  session = GoogleDrive.login(name, sec)
  WS = session.spreadsheet_by_key("0AiSCCf09bcHFdHRMa3VHQUNuZGpaUkJZRzVPUk1LWmc").worksheets[0]

  # get '/' do
  #   redirect to('/scenes')
  # end
  #
  # get '/lines' do
  #   scene = params[:by_scene]
  #   erb :index, locals: { tree: get_lines_as_tree(scene), scene: scene }
  # end
  #
  # get '/scenes' do
  #   erb :scenes, locals: { scenes: get_scenes }
  # end
  #
  # get '/scenes.json' do
  #   content_type :json
  #   get_scenes.to_json
  # end
  #
  # get '/characters.json' do
  #   content_type :json
  #   WS.list.collect {|row| row["character"]}.to_json
  # end
  #
  # get '/tags.json' do
  #   content_type :json
  #   WS.list.collect {|row| row["tags"]}.to_json
  # end
  #
  # post '/update' do
  #   puts params
  #   line = update_or_add_row(params)
  #   erb :line, locals: {line: line, index: 0}, layout: false
  # end
  #
  # post '/new_line' do
  #   new_line = Line.new(params)
  #   erb :line, locals: {line: new_line, index: 0}, layout: false
  # end
  #
  # private
  # def get_lines_as_tree(scene)
  #   WS.reload
  #   rows = WS.list.select {|row| row["scene"] == scene}
  #   lines = rows.collect {|r| Line.create_from_row(r)}
  #   DialogTree.build_tree(lines)
  # end
  #
  def get_lines(scene = nil)
    WS.reload
    lines = []
    WS.rows[1..-1].each do |row|
      # line = Line.create_from_row(row)
      lines << line if !scene or scene == line.scene
    end
    lines << Line.new(:scene => scene, :character => lines[-2].character)
  end
  #
  # def get_scenes
  #   WS.reload
  #   WS.list.collect {|row| row["scene"]}.uniq
  # end
  #
  # def update_or_add_row(line_data)
  #   line = Line.new(line_data)
  #   row_to_update = nil
  #   WS.list.each do |row|
  #     row_id = row["id"]
  #     if row_id == line.id
  #       row_to_update = row
  #       break
  #     end
  #   end
  #
  #   if row_to_update
  #     row_to_update.update(line.to_hash)
  #   else # new row
  #     WS.list.push(line.to_hash)
  #   end
  #   WS.save
  #   line
  # end
end
