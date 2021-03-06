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

ActiveRecord::Schema.define(version: 2019_08_07_015748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "subscription_list_id", null: false
    t.integer "capacity"
    t.text "description", null: false
    t.datetime "datetime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.string "location"
    t.boolean "deleted"
    t.string "gcal_event_id"
    t.index ["datetime"], name: "index_events_on_datetime", unique: true
    t.index ["subscription_list_id"], name: "index_events_on_subscription_list_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.integer "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["user_id"], name: "index_rsvps_on_user_id"
  end

  create_table "subscription_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_list_id"], name: "index_subscriptions_on_subscription_list_id"
    t.index ["user_id", "subscription_list_id"], name: "index_subscriptions_on_user_id_and_subscription_list_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "syndications", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_syndications_on_event_id"
    t.index ["user_id"], name: "index_syndications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "email_confirmed", null: false
    t.string "email_address", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin_confirmed", null: false
    t.string "email_backup"
    t.string "email_confirmation_code"
    t.boolean "user_confirmed"
    t.integer "invitation_type", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
