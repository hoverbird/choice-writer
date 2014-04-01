# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'multi_json'
MultiJson.use :yajl

# Initialize the Rails application.
Choice::Application.initialize!
