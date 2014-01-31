# require "bundler"
require 'google_drive'
require 'erubis'
require 'sinatra'
require 'json'
require 'hashie'
set :erb, :escape_html => true
# set :public_folder, 'static'
                                                     name, sec = "patrick@camposanto.com", "c4mp3s1n0"
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(name, sec)
WS = session.spreadsheet_by_key("0AoAp79Ob8GbIdDVtN1VQQ0dnQi1FQWh1ZlhKUXJURXc").worksheets[0]

class Line < Hashie::Dash
  property :id#, :required => true
  property :text
  property :character
  property :tags
  property :previous_line_id
end

def get_lines
  WS.reload
  puts WS.list[1].to_hash
  lines = WS.rows[1..-1].collect do |row|
    Line.new(
      :id => row[0],
      :character => row[1],
      :text => row[2],
      :tags => row[5]
    )
  end
  lines << Line.new
end

def update_or_add_row(data)
  line_id = data["Line ID"]
  line_data = data

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

get '/' do
  erb :index, locals: {lines: get_lines}
end

get '/rows' do
  WS.reload
  s = ""
  for row in 1..WS.num_rows
    for col in 1..WS.num_cols
      s << WS[row, col] + "\n"
    end
  end
  s
end
# Dumps all cells.

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

