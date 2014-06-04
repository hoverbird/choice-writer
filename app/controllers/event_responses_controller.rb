class EventResponsesController < ApplicationController

  def index
    event_responses = EventResponse.all.to_a
    event_responses_coll = EventResponse.serialize_collection(event_responses)
    respond_to do |format|
      format.json { render :json => event_responses_coll }
    end
  end

  def show
    event_response = EventResponse.find(params[:id])
    event_responses_coll = EventResponse.serialize_collection(event_response.expand_chain)

    respond_to do |format|
      format.json { render :json => event_responses_coll }
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

  def by_folder
    #TODO: this is a hack for demo purposes. remove
    # if params[:id] == '7'
    #   event_responses_ids = [1149, 1155, 1151, 1156, 1153]
    #   event_responses = event_responses_ids.collect {|id| EventResponse.find(id)}
    # else
    event_responses = EventResponse.where(folder_id: params[:id]).to_a
    # end
    event_responses_coll = EventResponse.serialize_collection(event_responses)

    respond_to do |format|
      format.json { render :json => event_responses_coll }
    end
  end

end
