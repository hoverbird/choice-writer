class FactMutation < ActiveRecord::Base
  belongs_to :fact
  belongs_to :fact_response, foreign_key: :response_id, dependent: :destroy
end
