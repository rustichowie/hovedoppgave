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

ActiveRecord::Schema.define(:version => 20130308105652) do

  create_table "cards", :force => true do |t|
    t.integer  "user_id"
    t.string   "card_value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cards", ["user_id", "card_value"], :name => "index_cards_on_user_id_and_card_value", :unique => true
  add_index "cards", ["user_id"], :name => "index_cards_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "log_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.integer  "logtype_id"
    t.integer  "workhours_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "logs", ["logtype_id"], :name => "index_logs_on_logtype_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
    t.string   "pin"
    t.string   "salt"
    t.string   "email"
    t.integer  "group_id",    :null => false
    t.integer  "role_id",     :null => false
  end

  add_index "users", ["group_id"], :name => "index_users_on_group_id"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

  create_table "workhours", :force => true do |t|
    t.datetime "start"
    t.datetime "stop"
    t.integer  "user_id",         :null => false
    t.integer  "count"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "approved"
    t.text     "comment"
    t.integer  "supervisor_hour"
  end

  add_index "workhours", ["user_id"], :name => "index_workhours_on_user_id"

end
