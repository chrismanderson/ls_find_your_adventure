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

ActiveRecord::Schema.define(:version => 20120628191232) do

  create_table "adventure_date_items", :force => true do |t|
    t.integer  "adventure_id"
    t.integer  "adventure_date_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "adventure_dates", :force => true do |t|
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "adventures", :force => true do |t|
    t.string   "title"
    t.string   "market"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "buy_url"
    t.string   "image_url"
    t.integer  "zipcode"
    t.text     "description"
    t.text     "details"
    t.integer  "price"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "sold_out"
    t.integer  "market_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "markets", :force => true do |t|
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
