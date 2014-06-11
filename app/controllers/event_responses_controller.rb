class EventResponsesController < ApplicationController

  def index
    event_responses = EventResponse.all.to_a
    respond_to do |format|
      format.json do
        render :json => EventResponse.serialize_collection(event_responses)
      end
    end
  end

  def show
    event_response = EventResponse.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => EventResponse.serialize_collection(event_response.expand_chain)
      end
    end
  end

  def search
    # TODO: this won't actually search on the ER name at present, just the responses
    event_responses = EventResponse.search(params[:q])
    event_responses_coll = EventResponse.serialize_collection(event_responses)

    respond_to do |format|
      format.json { render :json => event_responses_coll }
    end
  end

  def create
    raise "Creating Event Responses needs to be reimplemented"
  end

  def update
    raise "Updating Event Responses needs to be implemented"
  end

  def responds_to_event
    event_responses = EventResponse.where(name: params[:event_name]).to_a.map {|er| er.expand_chain}.flatten
    respond_to do |format|
      format.json { render :json => EventResponse.serialize_collection(event_responses) }
    end
  end

  def by_folder
    event_responses = EventResponse.where(folder_id: params[:id]).to_a

    respond_to do |format|
      format.json { render :json => EventResponse.serialize_collection(event_responses) }
    end
  end

end
