class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :event_responses, through: :taggings
end
