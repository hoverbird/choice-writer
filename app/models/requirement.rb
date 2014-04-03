class Requirement < ActiveRecord::Base
  belongs_to :fact
  belongs_to :event
end
