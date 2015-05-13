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

ActiveRecord::Schema.define(version: 20150511034752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "partner_costs", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performances", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "content"
    t.boolean  "permission",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "approver_id"
  end

  create_table "project_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_members", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "group_id"
    t.string   "order"
    t.string   "project_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "rank_histories", force: true do |t|
    t.integer  "user_id"
    t.date     "start_time"
    t.date     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank_id"
  end

  create_table "rank_masters", force: true do |t|
    t.string   "rank"
    t.integer  "cost"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "authority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

end
