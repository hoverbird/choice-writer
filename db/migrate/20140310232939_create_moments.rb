#encoding: utf-8

class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :kind, null: false, default: "Speech"
      t.references :previous_moment
      t.references :project
      t.text :text
      t.string :character
      t.string :location, null: false, default: "Anywhere"
      t.string :audio_file_path

      t.decimal :buffer_seconds, precision: 5, scale: 3

      t.index :project_id
      t.index :previous_moment_id
      t.index :location
      t.index :character

      t.timestamps
    end

    create_table :facts do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.string :default_value

      t.index :name, :unique => true
    end

    create_table :constraints do |t|
      t.references :moment
      t.references :fact
      t.string :fact_test, default: "be_true", null: false
      t.string :fact_test_value

      t.index [:moment_id, :fact_id]
      t.timestamps
    end

  end
end
