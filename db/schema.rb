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

ActiveRecord::Schema.define(version: 20171203210147) do

  create_table "events", force: :cascade do |t|
    t.integer "subscription_list_id", null: false
    t.date "date", null: false
    t.integer "capacity"
    t.text "description", null: false
    t.time "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_events_on_date", unique: true
    t.index ["subscription_list_id"], name: "index_events_on_subscription_list_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.boolean "confirmed", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
    t.index ["uuid"], name: "index_subscribers_on_uuid", unique: true
  end

  create_table "subscription_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "subscriber_id", null: false
    t.integer "subscription_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id", "subscription_list_id"], name: "index_subscriptions_on_subscriber_id_and_subscription_list_id", unique: true
    t.index ["subscriber_id"], name: "index_subscriptions_on_subscriber_id"
    t.index ["subscription_list_id"], name: "index_subscriptions_on_subscription_list_id"
  end

  create_table "syndications", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "subscriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_syndications_on_event_id"
    t.index ["subscriber_id"], name: "index_syndications_on_subscriber_id"
  end

end
