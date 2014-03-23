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

ActiveRecord::Schema.define(version: 20140320215021) do

  create_table "constraints", force: true do |t|
    t.integer  "moment_id"
    t.integer  "fact_id"
    t.string   "fact_test",       default: "be_true", null: false
    t.string   "fact_test_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "constraints", ["moment_id", "fact_id"], name: "index_constraints_on_moment_id_and_fact_id"

  create_table "facts", force: true do |t|
    t.string "name",          null: false
    t.text   "description"
    t.string "default_value"
  end

  add_index "facts", ["name"], name: "index_facts_on_name", unique: true

  create_table "folders", force: true do |t|
    t.string  "name"
    t.integer "parent_id"
  end

  create_table "moments", force: true do |t|
    t.string   "kind",                                       default: "Speech",   null: false
    t.integer  "previous_moment_id"
    t.integer  "project_id"
    t.integer  "folder_id"
    t.text     "text"
    t.string   "character"
    t.string   "location",                                   default: "Anywhere", null: false
    t.string   "audio_file_path"
    t.decimal  "buffer_seconds",     precision: 5, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moments", ["character"], name: "index_moments_on_character"
  add_index "moments", ["folder_id"], name: "index_moments_on_folder_id"
  add_index "moments", ["location"], name: "index_moments_on_location"
  add_index "moments", ["previous_moment_id"], name: "index_moments_on_previous_moment_id"
  add_index "moments", ["project_id"], name: "index_moments_on_project_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer "tag_id"
    t.integer "moment_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name",       null: false
    t.string   "folder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
