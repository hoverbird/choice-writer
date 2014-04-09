#encoding: utf-8

class NewSchema < ActiveRecord::Migration
  def change

    create_table :event_responses do |t|
      t.references :folder

      t.string :name, null: false
      t.string :description, unique: true

      t.index :folder_id
      t.timestamps
    end

    create_table :facts do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.string :default_value
      t.index :name, :unique => true
    end

    create_table :requirements do |t|
      t.references :event_response
      t.references :fact

      t.string :fact_test, default: "be_true", null: false
      t.string :fact_test_value

      t.index [:event_response_id, :fact_id]
    end

    create_table :fact_mutations do |t|
      t.references :response
      t.references :fact

      t.string :new_value

      t.index [:response_id, :fact_id]
    end

    create_table :responses do |t|
      t.references :event_response
      t.string :type, null: false, default: "Speech"
      t.string :on_finish_event_name

      t.text :text
      t.string :character
      t.string :location

      t.string :audio_clip_path
      t.decimal :on_finish_event_delay, precision: 5, scale: 3
      t.decimal :minimum_duration, precision: 5, scale: 3
      t.decimal :hack_audio_duration, precision: 5, scale: 3
      t.boolean :allow_queueing

      t.index :event_response_id
      t.index :character

      t.timestamps
    end

  end
end
