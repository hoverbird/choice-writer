class FactMutation < ActiveRecord::Base
  belongs_to :fact
  belongs_to :response
end
