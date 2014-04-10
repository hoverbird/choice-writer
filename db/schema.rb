# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140410005326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: true do |t|
    t.integer "dialog_tree_response_id",                 null: false
    t.string  "event_name",                              null: false
    t.string  "text",                    default: "...", null: false
  end

  add_index "choices", ["dialog_tree_response_id"], name: "index_choices_on_dialog_tree_response_id", using: :btree

  create_table "event_responses", force: true do |t|
    t.integer  "folder_id"
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_responses", ["folder_id"], name: "index_event_responses_on_folder_id", using: :btree

  create_table "fact_mutations", force: true do |t|
    t.integer "response_id"
    t.integer "fact_id"
    t.string  "new_value"
  end

  add_index "fact_mutations", ["response_id", "fact_id"], name: "index_fact_mutations_on_response_id_and_fact_id", using: :btree

  create_table "facts", force: true do |t|
    t.string "name",          null: false
    t.text   "description"
    t.string "default_value"
  end

  add_index "facts", ["name"], name: "index_facts_on_name", unique: true, using: :btree

  create_table "folders", force: true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "project_id"
  end

  add_index "folders", ["project_id", "parent_id"], name: "index_folders_on_project_id_and_parent_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirements", force: true do |t|
    t.integer "event_response_id"
    t.integer "fact_id"
    t.string  "fact_test",         default: "be_true", null: false
    t.string  "fact_test_value"
  end

  add_index "requirements", ["event_response_id", "fact_id"], name: "index_requirements_on_event_response_id_and_fact_id", using: :btree

  create_table "responses", force: true do |t|
    t.integer  "event_response_id"
    t.string   "type",                                          default: "Speech", null: false
    t.string   "on_finish_event_name"
    t.text     "text"
    t.string   "character"
    t.string   "location"
    t.string   "audio_clip_path"
    t.decimal  "on_finish_event_delay", precision: 5, scale: 3
    t.decimal  "minimum_duration",      precision: 5, scale: 3
    t.decimal  "hack_audio_duration",   precision: 5, scale: 3
    t.boolean  "allow_queueing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["character"], name: "index_responses_on_character", using: :btree
  add_index "responses", ["event_response_id"], name: "index_responses_on_event_response_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer "tag_id"
    t.integer "event_response_id"
  end

  add_index "taggings", ["tag_id", "event_response_id"], name: "index_taggings_on_tag_id_and_event_response_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
