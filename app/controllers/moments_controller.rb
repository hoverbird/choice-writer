class MomentsController < ApplicationController
  respond_to :json

  def index
    respond_with Moment.all
  end

  def location
    respond_with Moment.where(location: params[:location])
  end

end
