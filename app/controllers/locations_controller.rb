class LocationsController < ApplicationController
  respond_to :json

  def index
    respond_with Moment.select(:location).distinct.collect(&:location)
  end

end
