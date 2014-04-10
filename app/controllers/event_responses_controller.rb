class EventResponsesController < ApplicationController

  def index
    event_responses = EventResponse.all.to_a
    respond_to do |format|
      format.json { render :json => EventResponse.collection_to_unity_hash(event_responses) }
    end
  end

  def for_unity
    raw_json = EventResponse.collection_as_unity_JSON(:all).target!
    # TODO: re-parsing and generating. stupid, inefficient. JBuilder should have pretty_generate >:(
    json_blob = JSON.pretty_generate(JSON.parse(raw_json))
    respond_to do |format|
      format.json { render :json => json_blob }
    end
  end
end
