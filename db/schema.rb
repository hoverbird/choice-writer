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

ActiveRecord::Schema.define(version: 20140407174735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: true do |t|
    t.integer "dialog_tree_id",                 null: false
    t.integer "event_id",                       null: false
    t.string  "text",           default: "...", null: false
  end

  add_index "choices", ["dialog_tree_id"], name: "index_choices_on_dialog_tree_id", using: :btree
  add_index "choices", ["event_id"], name: "index_choices_on_event_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer "event_id"
    t.integer "fact_id"
    t.string  "fact_test",       default: "be_true", null: false
    t.string  "fact_test_value"
  end

  add_index "requirements", ["event_id", "fact_id"], name: "index_requirements_on_event_id_and_fact_id", using: :btree

  create_table "responses", force: true do |t|
    t.string   "type",                                          default: "Speech", null: false
    t.integer  "event_id"
    t.integer  "on_finish_event_id"
    t.integer  "folder_id"
    t.text     "text"
    t.string   "character"
    t.string   "audio_clip_path"
    t.decimal  "on_finish_event_delay", precision: 5, scale: 3
    t.decimal  "minimum_duration",      precision: 5, scale: 3
    t.decimal  "hack_audio_duration",   precision: 5, scale: 3
    t.boolean  "allow_queueing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.tsvector "search_vector"
  end

  add_index "responses", ["character"], name: "index_responses_on_character", using: :btree
  add_index "responses", ["event_id"], name: "index_responses_on_event_id", using: :btree
  add_index "responses", ["folder_id"], name: "index_responses_on_folder_id", using: :btree
  add_index "responses", ["search_vector"], name: "responses_search_idx", using: :gin

  create_table "taggings", force: true do |t|
    t.integer "tag_id"
    t.integer "response_id"
  end

  add_index "taggings", ["tag_id", "response_id"], name: "index_taggings_on_tag_id_and_response_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
