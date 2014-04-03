class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.references :parent
      t.references :project
      t.index [:project_id, :parent_id]
    end
  end
end
