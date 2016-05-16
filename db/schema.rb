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

ActiveRecord::Schema.define(version: 20160511144457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "helps", force: :cascade do |t|
    t.string "title"
    t.string "text"
  end

  create_table "panoplies", force: :cascade do |t|
    t.integer "quantity"
    t.integer "product_id_1"
    t.integer "product_id_2"
    t.integer "solo_sales"
  end

  create_table "products", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "website"
    t.string   "web_pic"
    t.integer  "total_sales"
    t.decimal  "price",       precision: 6, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "price",      precision: 6, scale: 2
    t.integer "ticket_id"
    t.integer "product_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "quantity"
    t.datetime "date"
    t.decimal  "total_worth", precision: 7, scale: 2
    t.string   "code"
    t.boolean  "read",                                default: false
  end

end
