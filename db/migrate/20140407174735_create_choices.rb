class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.references :dialog_tree, null: false
      t.references :event, null: false
      t.string :text, null: false, default: "..."

      t.index :event_id
      t.index :dialog_tree_id
    end
  end
end
