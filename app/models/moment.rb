class Moment < ActiveRecord::Base
  belongs_to :next_moment, class_name: "Moment", foreign_key: "next_moment_id"
end
