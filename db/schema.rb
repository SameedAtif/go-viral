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

ActiveRecord::Schema[7.0].define(version: 2023_06_10_082011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_clients_on_user_id", unique: true
  end

  create_table "gig_clients", force: :cascade do |t|
    t.bigint "gig_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_gig_clients_on_client_id"
    t.index ["gig_id"], name: "index_gig_clients_on_gig_id"
  end

  create_table "gig_platforms", force: :cascade do |t|
    t.bigint "gig_id"
    t.bigint "platform_id"
    t.index ["gig_id"], name: "index_gig_platforms_on_gig_id"
    t.index ["platform_id"], name: "index_gig_platforms_on_platform_id"
  end

  create_table "gigs", force: :cascade do |t|
    t.bigint "influencer_id"
    t.string "title"
    t.index ["influencer_id"], name: "index_gigs_on_influencer_id"
  end

  create_table "influencer_platforms", force: :cascade do |t|
    t.bigint "influencer_id"
    t.bigint "platform_id"
    t.index ["influencer_id"], name: "index_influencer_platforms_on_influencer_id"
    t.index ["platform_id"], name: "index_influencer_platforms_on_platform_id"
  end

  create_table "influencers", force: :cascade do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_influencers_on_user_id", unique: true
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "url", default: "", null: false
  end

  create_table "project_influencers", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "influencer_id"
    t.index ["influencer_id"], name: "index_project_influencers_on_influencer_id"
    t.index ["project_id"], name: "index_project_influencers_on_project_id"
  end

  create_table "project_platforms", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "platform_id"
    t.index ["platform_id"], name: "index_project_platforms_on_platform_id"
    t.index ["project_id"], name: "index_project_platforms_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "client_id"
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "clients", "users"
  add_foreign_key "gig_clients", "clients"
  add_foreign_key "gig_clients", "gigs"
  add_foreign_key "gig_platforms", "gigs"
  add_foreign_key "gig_platforms", "platforms"
  add_foreign_key "gigs", "influencers"
  add_foreign_key "influencer_platforms", "influencers"
  add_foreign_key "influencer_platforms", "platforms"
  add_foreign_key "influencers", "users"
  add_foreign_key "project_influencers", "influencers"
  add_foreign_key "project_influencers", "projects"
  add_foreign_key "project_platforms", "platforms"
  add_foreign_key "project_platforms", "projects"
  add_foreign_key "projects", "clients"
end
