class FactsController < ApplicationController
  respond_with :json

  def index
    @facts = Fact.all
    respond_with @facts
  end
end
