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

ActiveRecord::Schema.define(version: 20150301001136) do

  create_table "feed_items", force: :cascade do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.string   "author"
    t.string   "html"
    t.string   "url"
    t.boolean  "is_saved"
    t.boolean  "is_read"
    t.datetime "created_on_time"
    t.datetime "published_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "title"
    t.string   "feed_url"
    t.string   "site_url"
    t.boolean  "is_spark",             default: false
    t.datetime "last_updated_on_time"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
