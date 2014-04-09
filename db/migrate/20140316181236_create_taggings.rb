class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag
      t.references :event_response

      t.index [:tag_id, :event_response_id]
    end
  end
end
