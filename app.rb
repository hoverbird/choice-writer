# require "bundler"
require 'google_drive'
require 'erubis'
require 'sinatra'
set :erb, :escape_html => true

                                                              name, sec = "patrick@camposanto.com", "c4mp3s1n0"
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(name, sec)
WS = session.spreadsheet_by_key("0AoAp79Ob8GbIdDVtN1VQQ0dnQi1FQWh1ZlhKUXJURXc").worksheets[0]

class Line
  attr_accessor :id, :text, :character
end

def get_lines
  WS.reload
  WS.rows[1..-1].collect do |row|
    line = Line.new
    line.id = row[0]
    line.character = row[1]
    line.text = row[2]
    line
  end
end

def add_row(data)
  line_id = data["id"]
  row_to_update = -1;

  for row in 2..WS.num_rows
    row_id = WS[row, 1]
    puts row, row_id
    if row_id == line_id
      puts "We have a winner", row_id
      row_to_update = row
      break
    end
  end

  row_to_update = WS.num_rows +  1 if row_to_update < 0 #this is a new row
  WS[row_to_update, 1] = line_id
  WS[row_to_update, 3] = data["text"]
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

post '/update' do
  add_row params
end

