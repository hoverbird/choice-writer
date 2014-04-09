class EventsController < ApplicationController
  def for_unity
    raw_json = Event.collection_as_unity_JSON(:all).target!
    # TODO: re-parsing and generating. stupid, inefficient. JBuilder should have pretty_generate >:(
    json_blob = JSON.pretty_generate(JSON.parse(raw_json))
    respond_to do |format|
      format.json { render :json => json_blob }
    end
  end
end
