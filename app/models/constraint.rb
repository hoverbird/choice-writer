class Constraint < ActiveRecord::Base
  belongs_to :fact
  belongs_to :moment
end
