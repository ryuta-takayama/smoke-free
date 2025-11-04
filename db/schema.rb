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

ActiveRecord::Schema[7.1].define(version: 2025_11_04_082032) do
  create_table "abstinence_sessions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_abstinence_sessions_on_user_id"
  end

  create_table "action_plans", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_action_plans_on_post_id"
    t.index ["user_id"], name: "index_action_plans_on_user_id"
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "goals", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "target_item", null: false
    t.integer "target_amount_jpy", null: false
    t.datetime "started_on", null: false
    t.datetime "achieved_on", null: false
    t.integer "status", default: 0, null: false, comment: "active=0,achieved=1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "likes", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_likes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "quotes", charset: "utf8mb3", force: :cascade do |t|
    t.text "text", null: false
    t.string "author", null: false
    t.string "source", default: "ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restart_challenges", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "started_at", null: false
    t.datetime "expire_at", null: false
    t.integer "status", default: 0, null: false, comment: "pending=0,success=1,failed=2"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "started_at"], name: "index_restart_challenges_on_user_id_and_started_at"
    t.index ["user_id"], name: "index_restart_challenges_on_user_id"
  end

  create_table "smoking_settings", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "daily_cigarette_count", null: false
    t.integer "cigarette_price_jpy", null: false
    t.integer "cigarette_per_pack", null: false
    t.datetime "quit_start_datetime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_smoking_settings_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname", default: "", null: false
    t.integer "age"
    t.text "reason_to_quit"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "abstinence_sessions", "users"
  add_foreign_key "action_plans", "posts"
  add_foreign_key "action_plans", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "restart_challenges", "users"
  add_foreign_key "smoking_settings", "users"
end
