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

ActiveRecord::Schema.define(version: 20160113015525) do

  create_table "products", force: :cascade do |t|
    t.string   "product_name"
    t.integer  "price"
    t.integer  "quantity"
    t.string   "instagram_image"
    t.text     "description"
    t.string   "magic_code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type"
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url"

  create_table "users", force: :cascade do |t|
    t.string   "store_name"
    t.string   "phone_number"
    t.string   "address"
    t.string   "email"
    t.text     "delivery_info"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "instagram_id"
    t.string   "store_image"
  end

end
