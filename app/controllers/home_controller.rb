class HomeController < ApplicationController

  def index
    render text: 'Sup!', layout: true
  end
end
