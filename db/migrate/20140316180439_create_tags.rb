class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :folder
      t.timestamps
    end
  end
end
