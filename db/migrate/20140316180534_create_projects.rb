class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, unique: true, null: false
      t.timestamps
    end
  end
end
