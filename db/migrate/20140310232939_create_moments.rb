#encoding: utf-8

class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :kind, null: false, default: "Speech"
      t.references :next_moment
      t.text :text
      t.string :character
      t.string :location
      t.string :audio_file_path

      t.text :tags
      t.decimal :buffer_seconds, precision: 5, scale: 3

      t.index :location
      #TODO: t.index :kind
      #TODO: t.index :character
      #TODO: t.index :next_moment_id

      t.timestamps
    end
  end
end
