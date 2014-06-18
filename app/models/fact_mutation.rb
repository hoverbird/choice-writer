class FactMutation < ActiveRecord::Base
  belongs_to :fact
  belongs_to :fact_response, foreign_key: :response_id, dependent: :destroy

  def humanized_new_status
    case new_value
      when "0.0" then 'f'
      when "1.0" then 't'
    end
  end

  def humanized_op
    case op
      when 0 then 'set'
    end
  end

end
