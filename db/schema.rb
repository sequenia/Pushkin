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

ActiveRecord::Schema.define(version: 20180924111952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pushkin_notifications", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "tokens_provider_id"
    t.string "tokens_provider_type"
    t.integer "payload_id"
    t.string "payload_type"
    t.string "notification_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type", "start_at"], name: "index_pushkin_notifications_on_notification_type_and_start_at"
    t.index ["payload_type", "payload_id"], name: "index_pushkin_notifications_on_payload_type_and_payload_id"
    t.index ["start_at", "started_at"], name: "index_pushkin_notifications_on_start_at_and_started_at"
    t.index ["tokens_provider_type", "tokens_provider_id"], name: "index_pushkin_nots_on_toks_provider_type_and_toks_provider_id"
  end

  create_table "pushkin_payloads", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.string "web_click_action"
    t.string "android_click_action"
    t.string "ios_click_action"
    t.string "web_icon"
    t.string "android_icon"
    t.string "ios_icon"
    t.string "data"
    t.boolean "is_android_data_message", default: false
    t.boolean "is_ios_data_message", default: false
    t.boolean "is_web_data_message", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pushkin_push_sending_results", force: :cascade do |t|
    t.boolean "success"
    t.string "error"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "notification_id"
    t.integer "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_pushkin_push_sending_results_on_notification_id"
  end

  create_table "pushkin_token_results", force: :cascade do |t|
    t.string "status"
    t.string "error"
    t.integer "push_sending_result_id"
    t.integer "token_id"
    t.index ["push_sending_result_id"], name: "index_pushkin_token_results_on_push_sending_result_id"
    t.index ["token_id"], name: "index_pushkin_token_results_on_token_id"
  end

  create_table "pushkin_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.integer "platform"
    t.boolean "is_active", default: true
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token", "platform"], name: "index_pushkin_tokens_on_token_and_platform", unique: true
    t.index ["user_id", "is_active"], name: "index_pushkin_tokens_on_user_id_and_is_active"
  end

  create_table "pushkin_tokens_provider_users", force: :cascade do |t|
    t.integer "tokens_provider_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tokens_provider_id"], name: "index_pushkin_tokens_provider_users_on_tokens_provider_id"
    t.index ["user_id"], name: "index_pushkin_tokens_provider_users_on_user_id"
  end

  create_table "pushkin_tokens_providers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login"
  end

end
