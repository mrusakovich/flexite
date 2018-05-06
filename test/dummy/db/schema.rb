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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20180503103109) do

  create_table "flexite_configs", :force => true do |t|
    t.string   "name"
    t.integer  "created_by"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "section_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "flexite_configs", ["parent_id"], :name => "index_flexite_configs_on_parent_id"
  add_index "flexite_configs", ["section_id"], :name => "index_flexite_configs_on_section_id"

  create_table "flexite_entries", :force => true do |t|
    t.string   "value"
    t.string   "type"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "flexite_entries", ["parent_id"], :name => "index_flexite_entries_on_parent_id"

  create_table "flexite_sections", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flexite_sections", ["parent_id"], :name => "index_flexite_sections_on_parent_id"

end
