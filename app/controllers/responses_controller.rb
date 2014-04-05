class ResponsesController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token #TODO: remove this, patch Backbone. This is totes unsafe for public consumption.

  def index
    respond_with Response.all
  end

  def search
    query = params[:query]
    respond_with Response.search(query)
  end

  def create
    respond_with Response.create(event_params)
  end

  def update
    response = Response.find(params[:id])
    if response.update_attributes!(event_params)
      respond_with response.to_json
    else
      error_message = "Failed to update Event."
      logger.info error_message
      head 500, error_message
    end
  end

  def destroy
    response = Response.find(params[:id])
    if response.destroy!
      respond_with response
    end
  end

  def by_tag
    respond_with Response.joins(:tags).where("name = ?", params[:tag_name]).to_a
  end

  def by_folder
    responses = Response.where folder_id: params[:folder_id]
    respond_with responses.to_a
  end

  private
    def event_params
      params.permit(:text, :character)
    end

end
