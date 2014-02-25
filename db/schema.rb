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

ActiveRecord::Schema.define(version: 20140224232946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "articles", force: true do |t|
    t.string  "title"
    t.text    "body"
    t.integer "author_id"
  end

  create_table "companies", force: true do |t|
    t.string   "name",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_employees"
    t.string   "total_money_raised"
    t.string   "twitter_username"
    t.string   "category_code"
    t.string   "city"
    t.integer  "twitter_followers"
    t.string   "career_page_link"
  end

  create_table "jobs", force: true do |t|
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "full_text"
    t.boolean  "is_draft"
    t.integer  "company_id"
    t.string   "dept"
    t.integer  "years_exp"
    t.string   "sub_dept"
    t.text     "description"
    t.string   "key_phrases", default: [], array: true
    t.string   "req_skills",  default: [], array: true
  end

  create_table "search_suggestions", force: true do |t|
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "popularity"
  end

  create_table "taxonomies", force: true do |t|
    t.string "title"
    t.string "level"
    t.string "base_title"
    t.string "dept"
    t.hstore "expert_phrases"
  end

  create_table "user_jobs", force: true do |t|
    t.integer "user_id"
    t.integer "saved_job_id"
    t.integer "applied_job_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",               null: false
    t.string   "password_digest",     null: false
    t.string   "session_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "job_settings"
    t.boolean  "is_admin"
    t.boolean  "guest"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "fname"
    t.string   "lname"
    t.string   "title"
    t.string   "location"
    t.integer  "company_id"
  end

end
