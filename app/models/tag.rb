class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :moments, through: :taggings
end
