# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_20_003933) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.text "address_line_1", null: false
    t.text "address_line_2"
    t.text "city", null: false
    t.text "state", null: false
    t.text "zip", null: false
    t.text "special_instructions"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "subscription_list_id", null: false
    t.integer "capacity"
    t.text "description", null: false
    t.datetime "datetime", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "uuid", null: false
    t.boolean "deleted"
    t.datetime "datetime_end", precision: nil
    t.bigint "address_id"
    t.index ["address_id"], name: "index_events_on_address_id"
    t.index ["datetime"], name: "index_events_on_datetime", unique: true
    t.index ["subscription_list_id"], name: "index_events_on_subscription_list_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.integer "response"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["user_id"], name: "index_rsvps_on_user_id"
  end

  create_table "special_event_syndications", force: :cascade do |t|
    t.bigint "special_event_id", null: false
    t.string "email_address"
    t.integer "rsvp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "invited", null: false
    t.index ["special_event_id"], name: "index_special_event_syndications_on_special_event_id"
  end

  create_table "special_events", force: :cascade do |t|
    t.string "uuid"
    t.integer "capacity"
    t.bigint "address_id"
    t.text "description", null: false
    t.datetime "datetime", null: false
    t.datetime "datetime_end", precision: nil
    t.boolean "deleted", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["address_id"], name: "index_special_events_on_address_id"
  end

  create_table "subscription_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_list_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["subscription_list_id"], name: "index_subscriptions_on_subscription_list_id"
    t.index ["user_id", "subscription_list_id"], name: "index_subscriptions_on_user_id_and_subscription_list_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "syndications", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["event_id"], name: "index_syndications_on_event_id"
    t.index ["user_id"], name: "index_syndications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "email_confirmed", null: false
    t.string "email_address", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "uuid", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "admin_confirmed", null: false
    t.string "email_backup"
    t.string "email_confirmation_code"
    t.boolean "user_confirmed"
    t.integer "invitation_type", null: false
    t.boolean "moderator"
    t.integer "vaccination_status"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
