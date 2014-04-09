class FactMutation < ActiveRecord::Base
  belongs_to :fact
  belongs_to :fact_response
end
