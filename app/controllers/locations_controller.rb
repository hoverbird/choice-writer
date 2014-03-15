class LocationsController < ApplicationController
  respond_to :json, :html

  def index
    @locations = Moment.select(:location).distinct.collect(&:location)
    respond_with @locations
  end

end
