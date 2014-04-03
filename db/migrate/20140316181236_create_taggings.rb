class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag
      t.references :response

      t.index [:tag_id, :response_id]
    end
  end
end
