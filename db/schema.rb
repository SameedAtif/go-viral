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

ActiveRecord::Schema[7.0].define(version: 2023_06_21_134346) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_clients_on_user_id", unique: true
  end

  create_table "gig_categories", force: :cascade do |t|
    t.bigint "gig_id"
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.float "price"
    t.index ["gig_id"], name: "index_gig_categories_on_gig_id"
  end

  create_table "gig_clients", force: :cascade do |t|
    t.bigint "gig_id"
    t.bigint "client_id"
    t.bigint "gig_category_id"
    t.index ["client_id"], name: "index_gig_clients_on_client_id"
    t.index ["gig_category_id"], name: "index_gig_clients_on_gig_category_id"
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
    t.string "title", default: "", null: false
    t.index ["influencer_id"], name: "index_gigs_on_influencer_id"
  end

  create_table "influencer_platforms", force: :cascade do |t|
    t.bigint "influencer_id"
    t.bigint "platform_id"
    t.integer "followers"
    t.float "reach"
    t.string "url"
    t.index ["influencer_id"], name: "index_influencer_platforms_on_influencer_id"
    t.index ["platform_id"], name: "index_influencer_platforms_on_platform_id"
  end

  create_table "influencers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "bio"
    t.index ["user_id"], name: "index_influencers_on_user_id", unique: true
  end

  create_table "organization_details", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "organization_id"
    t.string "client_role", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_organization_details_on_client_id", unique: true
    t.index ["organization_id"], name: "index_organization_details_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "address_1", default: "", null: false
    t.string "address_2", default: "", null: false
    t.string "city", default: "", null: false
    t.string "country", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "url", default: "", null: false
  end

  create_table "project_applications", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "influencer_id"
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.string "status", default: "", null: false
    t.float "budget"
    t.datetime "delivery_date"
    t.index ["influencer_id"], name: "index_project_applications_on_influencer_id"
    t.index ["project_id"], name: "index_project_applications_on_project_id"
  end

  create_table "project_deliverable_reviews", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "project_id"
    t.bigint "project_deliverable_id"
    t.integer "achieved_reach", default: 0, null: false
    t.integer "achieved_conversion", default: 0, null: false
    t.string "remarks", default: "", null: false
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_project_deliverable_reviews_on_client_id"
    t.index ["project_deliverable_id"], name: "index_project_deliverable_reviews_on_project_deliverable_id"
    t.index ["project_id"], name: "index_project_deliverable_reviews_on_project_id"
  end

  create_table "project_deliverables", force: :cascade do |t|
    t.bigint "project_milestone_id"
    t.bigint "influencer_id"
    t.string "title", default: "", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["influencer_id"], name: "index_project_deliverables_on_influencer_id"
    t.index ["project_milestone_id"], name: "index_project_deliverables_on_project_milestone_id"
  end

  create_table "project_influencers", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "influencer_id"
    t.index ["influencer_id"], name: "index_project_influencers_on_influencer_id"
    t.index ["project_id"], name: "index_project_influencers_on_project_id"
  end

  create_table "project_milestones", force: :cascade do |t|
    t.bigint "project_id"
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.integer "reach", null: false
    t.integer "conversion", null: false
    t.float "budget", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_milestones_on_project_id"
  end

  create_table "project_platforms", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "platform_id"
    t.index ["platform_id"], name: "index_project_platforms_on_platform_id"
    t.index ["project_id"], name: "index_project_platforms_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "client_id"
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.float "budget", default: 0.0, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "required_number_of_influencers", default: 1, null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "user_roles", default: [], array: true
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
  add_foreign_key "gig_categories", "gigs"
  add_foreign_key "gig_clients", "clients"
  add_foreign_key "gig_clients", "gig_categories"
  add_foreign_key "gig_clients", "gigs"
  add_foreign_key "gig_platforms", "gigs"
  add_foreign_key "gig_platforms", "platforms"
  add_foreign_key "gigs", "influencers"
  add_foreign_key "influencer_platforms", "influencers"
  add_foreign_key "influencer_platforms", "platforms"
  add_foreign_key "influencers", "users"
  add_foreign_key "organization_details", "clients"
  add_foreign_key "organization_details", "organizations"
  add_foreign_key "project_applications", "influencers"
  add_foreign_key "project_applications", "projects"
  add_foreign_key "project_deliverable_reviews", "clients"
  add_foreign_key "project_deliverable_reviews", "project_deliverables"
  add_foreign_key "project_deliverable_reviews", "projects"
  add_foreign_key "project_deliverables", "influencers"
  add_foreign_key "project_deliverables", "project_milestones"
  add_foreign_key "project_influencers", "influencers"
  add_foreign_key "project_influencers", "projects"
  add_foreign_key "project_milestones", "projects"
  add_foreign_key "project_platforms", "platforms"
  add_foreign_key "project_platforms", "projects"
  add_foreign_key "projects", "clients"
end
