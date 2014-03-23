class Folder < ActiveRecord::Base
  has_many :moments
  belongs_to :parent, class_name: "Folder", foreign_key: "folder_id"
end
