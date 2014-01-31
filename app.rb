# require "bundler"
require 'google_drive'
require 'sinatra'
                                                              name, sec = "patrick@camposanto.com", "c4mp3s1n0"
# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login(name, sec)

# Gets list of remote files.
# for file in session.files
#   p file.title
# end

ws = session.spreadsheet_by_key("0AoAp79Ob8GbIdDVtN1VQQ0dnQi1FQWh1ZlhKUXJURXc").worksheets[0]

get '/' do
  ws.reload
  s = ""
  for row in 1..ws.num_rows
    for col in 1..ws.num_cols
      s << ws[row, col] + "\n"
    end
  end
  s
end
# Dumps all cells.

get '/update' do
  ws[1, 3] = params["heard"]
  ws.save
end

# Yet another way to do so.
# p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
# ws.reload