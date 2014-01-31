# require "bundler"
require 'google_drive'
require 'sinatra'
                                                              name, sec = "patrick@camposanto.com", "c4mp3s1n0"
# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(name, sec)
index = File.read 'index.html'
WS = session.spreadsheet_by_key("0AoAp79Ob8GbIdDVtN1VQQ0dnQi1FQWh1ZlhKUXJURXc").worksheets[0]

def add_row(data)
  dialog_id = data["id"]
  row_to_update = -1;

  for row in 2..WS.num_rows
    row_id = WS[row, 1]
    puts row, row_id
    if row_id == dialog_id
      puts "We have a winner", row_id
      row_to_update = row
      break
    end
  end

  row_to_update = WS.num_rows +  1 if row_to_update < 0 #this is a new row
  WS[row_to_update, 1] = dialog_id
  WS[row_to_update, 3] = "Sinbad"
  WS[row_to_update, 3] = data["heard"]
  WS.save
end

get '/' do
  index
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

# Yet another way to do so.
# p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
# ws.reload