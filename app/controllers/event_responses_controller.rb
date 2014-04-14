class EventResponsesController < ApplicationController

  def index
    event_responses = EventResponse.all.to_a
    event_responses_hash = EventResponse.collection_to_web_hash(event_responses)

    respond_to do |format|
      format.json { render :json => event_responses_hash }
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
