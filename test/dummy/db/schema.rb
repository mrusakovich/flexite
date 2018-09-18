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

ActiveRecord::Schema.define(:version => 20181001090735) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "flexite_configs", :force => true do |t|
    t.string   "name"
    t.boolean  "selectable",  :default => true
    t.integer  "config_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "description"
  end

  add_index "flexite_configs", ["config_id"], :name => "index_flexite_configs_on_config_id"

  create_table "flexite_entries", :force => true do |t|
    t.string   "value"
    t.string   "type"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "flexite_entries", ["parent_id"], :name => "index_flexite_entries_on_parent_id"
  add_index "flexite_entries", ["parent_type"], :name => "index_flexite_entries_on_parent_type"

  create_table "flexite_histories", :force => true do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "flexite_histories", ["entity_id"], :name => "index_flexite_histories_on_entity_id"
  add_index "flexite_histories", ["entity_type"], :name => "index_flexite_histories_on_entity_type"

  create_table "flexite_history_attributes", :force => true do |t|
    t.integer  "history_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flexite_history_attributes", ["history_id"], :name => "index_flexite_history_attributes_on_history_id"

  create_table "flexite_job_reports", :force => true do |t|
    t.string   "file_name"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
