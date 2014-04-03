#encoding: utf-8

class NewSchema < ActiveRecord::Migration
  def change

    create_table :events do |t|
      t.string :name, unique: true, null: false
      t.string :description, unique: true
      t.timestamps
    end

    create_table :facts do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.string :default_value
      t.index :name, :unique => true
    end

    create_table :requirements do |t|
      t.references :event
      t.references :fact
      t.string :fact_test, default: "be_true", null: false
      t.string :fact_test_value

      t.index [:event_id, :fact_id]
    end

    create_table :responses do |t|
      t.string :type, null: false, default: "Speech"
      t.references :event
      t.references :on_finish_event
      t.references :folder

      t.text :text
      t.string :character

      t.string :audio_clip_path
      t.decimal :on_finish_event_delay, precision: 5, scale: 3
      t.decimal :minimum_duration, precision: 5, scale: 3
      t.decimal :hack_audio_duration, precision: 5, scale: 3
      t.boolean :allow_queueing

      t.index :event_id
      t.index :folder_id
      t.index :character

      t.timestamps
    end
    
  end
end
