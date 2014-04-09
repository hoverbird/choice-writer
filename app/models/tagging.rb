class Tagging < ActiveRecord::Base
  belongs_to :event_response
  belongs_to :tag
end
