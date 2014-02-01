require 'google_drive'
require 'erubis'
require 'sinatra'
require 'json'
require 'models/line'
require 'models/dialog_tree'

set :erb, :escape_html => true
                                                               name, sec = "patrick@camposanto.com", "c4mp3s1n0"
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(name, sec)
WS = session.spreadsheet_by_key("0AoAp79Ob8GbIdDVtN1VQQ0dnQi1FQWh1ZlhKUXJURXc").worksheets[0]

get '/lines' do
  scene = params[:by_scene]
  erb :index, locals: { lines: get_lines(scene), scene: scene }
end

get '/scenes' do
  erb :scenes, locals: { scenes: get_scenes }
end

get '/scenes.json' do
  content_type :json
  get_scenes.to_json
end

get '/characters.json' do
  content_type :json
  WS.list.collect {|row| row["Character"]}.to_json
end

get '/tags.json' do
  content_type :json
  WS.list.collect {|row| row["Tags"]}.to_json
end

post '/update' do
  update_or_add_row params
end

def generate_id
  SecureRandom.uuid
end

def get_lines_as_tree(scene)
  WS.reload
  rows = WS.list.select {|s| s == scene}
  lines = rows.collect {|r| Line.create_from_row(r)}
  DialogTree.build_tree(tree, lines)
end


def get_lines(scene = nil)
  WS.reload
  lines = []
  WS.rows[1..-1].each do |row|
    line = Line.create_from_row(row)
    lines << line if !scene or scene == line.scene
  end
  lines << Line.new(:id => generate_id, :scene => scene, :character => lines[-2].character)
end

def get_scenes
  WS.reload
  WS.list.collect {|row| row["Scene"]}.uniq
end

def update_or_add_row(line_data)
  line_id = line_data["Line ID"]

  row_to_update = nil
  WS.list.each do |row|
    row_id = row["Line ID"]
    if row_id == line_id
      row_to_update = row
      break
    end
  end

  if row_to_update
    row_to_update.update(line_data)
  else # new row
    WS.list.push(line_data)
  end
  WS.save
end


