class Event < ActiveRecord::Base
  has_many :responses
  has_many :requirements
end
