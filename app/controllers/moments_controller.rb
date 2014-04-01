class MomentsController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token #TODO: remove this, patch Backbone. This is totes unsafe for public consumption.

  DEFAULT_PROJECT_ID = 1

  def index
    if location_id = params[:location]
      respond_with Moment.where(location: location_id).all
    else
      respond_with Moment.all
    end
  end

  def create
    respond_with Moment.create(moment_params)
  end

  def update
    moment = Moment.find(params[:id])
    if moment.update_attributes!(moment_params)
      respond_with moment.to_json
    else
      error_message = "Failed to update Moment."
      logger.info error_message
      head 500, error_message
    end
  end

  def destroy
    moment = Moment.find(params[:id])
    if moment.destroy!
      respond_with moment
    end
  end

  def location
    respond_with Moment.where(location: params[:location])
  end

  def by_tag
    respond_with Moment.joins(:tags).where("name = ?", params[:tag_name]).to_a
  end

  def by_folder
    moments = Moment.where folder_id: params[:folder_id]
    respond_with moments.to_a
  end

  def for_unity
    json_blob = Moment.collection_as_unity_JSON(:all).target!
    respond_to do |format|
      format.json { render :json => json_blob }
    end
  end

  private
    def moment_params
      params.permit(:text, :character, :location)
    end

end
