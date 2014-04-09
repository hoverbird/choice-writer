require 'google_drive'
require 'erubis'
require 'sinatra'
require 'json'
require 'hashie'
require 'redcarpet'

class EventResponse < Hashie::Mash
  # GENERAL AREA	CONCEPT	EVENT NAME	REQUIREMENTS	RESPONSE TYPE	CHARACTER	CAPTION	DESCRIPTION OR NOTES	ON FINISH EVENT	IMPLEMENTED?
  # property :id, :required => true, :default => lambda {SecureRandom.uuid}
  # property :scene, :required => true
end

class EventResponseImporter
  def initialize
    @name, @sec = "patrick@camposanto.com", "c4mp3s1n0"
    @session = GoogleDrive.login(@name, @sec)
    @worksheet = @session.spreadsheet_by_key("0AiSCCf09bcHFdHRMa3VHQUNuZGpaUkJZRzVPUk1LWmc").worksheets[0]
  end

  def rows
    @rows ||= @worksheet.list.collect {|row| EventResponse.new(row)}
  end
end
