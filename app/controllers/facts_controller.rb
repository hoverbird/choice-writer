class FactsController < ApplicationController
  respond_to :json

  def index
    @facts = Fact.all
    respond_with @facts
  end
end
