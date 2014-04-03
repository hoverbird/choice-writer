class Folder < ActiveRecord::Base
  has_many :responses
  belongs_to :parent, class_name: "Folder", foreign_key: "folder_id"
end
