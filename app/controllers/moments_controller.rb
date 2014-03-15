class MomentsController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token #TODO: remove this, patch Backbone. This is totes unsafe for public consumption.

  def index
    if location_id = params[:location]
      respond_with Moment.where(location: location_id).all
    else
      respond_with Moment.all
    end
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

  def location
    respond_with Moment.where(location: params[:location])
  end

  private
    def moment_params
      params.permit(:text, :character, :location)
    end

end
