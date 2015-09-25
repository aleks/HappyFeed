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

ActiveRecord::Schema.define(version: 20150925140540) do

  create_table "feed_item_reads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.integer  "feed_item_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "feed_item_reads", ["feed_id"], name: "index_feed_item_reads_on_feed_id"
  add_index "feed_item_reads", ["feed_item_id"], name: "index_feed_item_reads_on_feed_item_id"
  add_index "feed_item_reads", ["user_id"], name: "index_feed_item_reads_on_user_id"

  create_table "feed_item_stars", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.integer  "feed_item_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "feed_item_stars", ["feed_id"], name: "index_feed_item_stars_on_feed_id"
  add_index "feed_item_stars", ["feed_item_id"], name: "index_feed_item_stars_on_feed_item_id"
  add_index "feed_item_stars", ["user_id"], name: "index_feed_item_stars_on_user_id"

  create_table "feed_items", force: :cascade do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.string   "author"
    t.string   "html"
    t.string   "url"
    t.datetime "created_on_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "feeds", force: :cascade do |t|
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

  create_table "user_feeds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_feeds", ["feed_id"], name: "index_user_feeds_on_feed_id"
  add_index "user_feeds", ["user_id"], name: "index_user_feeds_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
