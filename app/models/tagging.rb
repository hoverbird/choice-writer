class Tagging < ActiveRecord::Base
  belongs_to :moment
  belongs_to :tag
end
