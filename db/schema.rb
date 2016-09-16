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

ActiveRecord::Schema.define(version: 20160916172503) do

  create_table "admin_settings", force: :cascade do |t|
    t.string   "jacket_season",            limit: 255,                           default: "2016"
    t.text     "jacket_description",       limit: 65535
    t.decimal  "raffle_ticket_cost",                     precision: 5, scale: 2, default: 5.0
    t.boolean  "raffle_open",              limit: 1,                             default: false
    t.string   "raffle_item_name",         limit: 255
    t.integer  "raffle_tickets_available", limit: 4,                             default: 50
    t.integer  "raffle_tickets_per_user",  limit: 4,                             default: 10
    t.text     "raffle_item_description",  limit: 65535
    t.integer  "commissioner_user_id",     limit: 4,                             default: 621
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.string   "headline",   limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "annual_events", force: :cascade do |t|
    t.string   "event_name", limit: 255
    t.integer  "start_year", limit: 4
    t.integer  "skip",       limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "election_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates_votes", id: false, force: :cascade do |t|
    t.integer "candidate_id", limit: 4
    t.integer "vote_id",      limit: 4
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,    default: ""
    t.text     "comment",          limit: 65535
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "competitors", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.boolean  "pair",                limit: 1,     default: false
    t.boolean  "team",                limit: 1,     default: false
    t.text     "bio",                 limit: 65535
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                limit: 255
  end

  create_table "disciplines", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "abbreviation",     limit: 255
    t.integer  "score_multiplier", limit: 4,   default: 1
    t.boolean  "active",           limit: 1,   default: true
    t.integer  "position",         limit: 4,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "discipline_group", limit: 255
    t.boolean  "free",             limit: 1,   default: false
  end

  create_table "elections", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.boolean  "active",      limit: 1,     default: true
    t.datetime "close_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_details", force: :cascade do |t|
    t.integer  "event_id",                  limit: 4
    t.text     "general_information",       limit: 65535
    t.text     "competitor_information",    limit: 65535
    t.text     "directions",                limit: 65535
    t.text     "accommodations",            limit: 65535
    t.text     "banquet",                   limit: 65535
    t.text     "auction",                   limit: 65535
    t.text     "sponsors",                  limit: 65535
    t.text     "schedule",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "registration_instructions", limit: 65535
    t.text     "waiver",                    limit: 65535
  end

  create_table "event_disciplines", force: :cascade do |t|
    t.integer  "event_id",      limit: 4
    t.integer  "discipline_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.integer  "competitor_id",         limit: 4
    t.integer  "event_id",              limit: 4
    t.decimal  "amount",                          precision: 7, scale: 2
    t.boolean  "paid",                  limit: 1,                         default: false
    t.boolean  "first_time_competitor", limit: 1,                         default: false
    t.boolean  "accepted_terms",        limit: 1,                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "volunteer_judge",       limit: 1,                         default: false
    t.boolean  "volunteer_field_staff", limit: 1,                         default: false
    t.boolean  "volunteer_setup_crew",  limit: 1,                         default: false
    t.integer  "saturday_lunches",      limit: 4,                         default: 0
    t.integer  "sunday_lunches",        limit: 4,                         default: 0
    t.integer  "number_for_dinner",     limit: 4,                         default: 0
  end

  create_table "event_sponsors", force: :cascade do |t|
    t.integer  "event_id",          limit: 4
    t.string   "name",              limit: 255
    t.string   "link_type",         limit: 255
    t.text     "url",               limit: 65535
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.integer  "organizer_id",                   limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "season_id",                      limit: 4
    t.string   "location",                       limit: 255
    t.string   "acronym",                        limit: 255
    t.string   "contact_name",                   limit: 255
    t.string   "contact_phone",                  limit: 255
    t.string   "contact_email",                  limit: 255
    t.string   "url",                            limit: 255
    t.string   "status",                         limit: 255
    t.boolean  "fee_received",                   limit: 1,                           default: false
    t.boolean  "results_available",              limit: 1,                           default: false
    t.boolean  "online_registration",            limit: 1,                           default: true
    t.datetime "registration_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration_form_file_name",    limit: 255
    t.string   "registration_form_content_type", limit: 255
    t.integer  "registration_form_file_size",    limit: 4
    t.datetime "registration_form_updated_at"
    t.decimal  "flat_rate",                                  precision: 5, scale: 2
    t.decimal  "base_rate",                                  precision: 5, scale: 2, default: 10.0
    t.decimal  "discipline_rate",                            precision: 5, scale: 2, default: 10.0
  end

  add_index "events", ["season_id"], name: "index_events_on_season_id", using: :btree
  add_index "events", ["start_date"], name: "index_events_on_start_date", using: :btree

  create_table "jackets", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "style",         limit: 255
    t.string   "size",          limit: 255
    t.string   "typeface",      limit: 255
    t.integer  "season_id",     limit: 4
    t.boolean  "delivery",      limit: 1
    t.decimal  "price",                     precision: 4, scale: 2
    t.string   "custom_text_1", limit: 255
    t.string   "custom_text_2", limit: 255
    t.string   "custom_text_3", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id",         limit: 4
    t.integer  "purchasable_id",   limit: 4
    t.string   "purchasable_type", limit: 255
    t.decimal  "amount",                       precision: 8, scale: 2
    t.string   "description",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "membership_plans", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.decimal  "amount",                     precision: 5, scale: 2
    t.integer  "renewal_period", limit: 4
    t.boolean  "visible",        limit: 1,                           default: true
    t.boolean  "primary",        limit: 1,                           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",               limit: 4,                 null: false
    t.integer  "membership_plan_id",    limit: 4,                 null: false
    t.datetime "expires_at"
    t.boolean  "primary_member",        limit: 1, default: true
    t.integer  "primary_user_id",       limit: 4
    t.integer  "primary_membership_id", limit: 4
    t.boolean  "paid",                  limit: 1, default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",                       limit: 4
    t.decimal  "amount",                                      precision: 8, scale: 2
    t.string   "state",                         limit: 255,                           default: "new"
    t.string   "paypal_status",                 limit: 255
    t.string   "paypal_transaction_identifier", limit: 255
    t.decimal  "paypal_fee",                                  precision: 8, scale: 2
    t.text     "encrypted_data",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "registration_disciplines", force: :cascade do |t|
    t.integer  "event_discipline_id",   limit: 4
    t.integer  "event_registration_id", limit: 4
    t.string   "group_name",            limit: 255
    t.text     "group_members",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "competitor_id",       limit: 4
    t.integer  "event_discipline_id", limit: 4
    t.decimal  "score",                           precision: 5, scale: 2
    t.boolean  "disqualified",        limit: 1,                           default: false
    t.integer  "rank",                limit: 4
    t.string   "tie_breaker",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points",              limit: 4,                           default: 0
    t.integer  "season_id",           limit: 4
    t.boolean  "current_member",      limit: 1,                           default: true
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "year",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",    limit: 1,   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", force: :cascade do |t|
    t.integer  "competitor_id",     limit: 4
    t.integer  "season_id",         limit: 4
    t.integer  "discipline_id",     limit: 4
    t.integer  "points",            limit: 4
    t.integer  "rank",              limit: 4
    t.integer  "competition_count", limit: 4
    t.string   "tie_breaker",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer  "competitor_id", limit: 4
    t.integer  "team_id",       limit: 4
    t.boolean  "captain",       limit: 1, default: false
    t.boolean  "sub",           limit: 1, default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                 limit: 255,                   null: false
    t.string   "crypted_password",      limit: 255,                   null: false
    t.string   "password_salt",         limit: 255,                   null: false
    t.string   "persistence_token",     limit: 255,                   null: false
    t.string   "single_access_token",   limit: 255,                   null: false
    t.string   "perishable_token",      limit: 255,                   null: false
    t.integer  "login_count",           limit: 4,     default: 0,     null: false
    t.integer  "failed_login_count",    limit: 4,     default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",      limit: 255
    t.string   "last_login_ip",         limit: 255
    t.string   "full_name",             limit: 255
    t.string   "nickname",              limit: 255
    t.string   "mailing_name",          limit: 255
    t.string   "additional_members",    limit: 255
    t.string   "store_affiliation",     limit: 255
    t.string   "street_address_1",      limit: 255
    t.string   "street_address_2",      limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zip",                   limit: 255
    t.string   "phone_number",          limit: 255
    t.boolean  "admin",                 limit: 1,     default: false
    t.boolean  "el_member",             limit: 1,     default: false
    t.boolean  "board_member",          limit: 1,     default: false
    t.boolean  "lifetime",              limit: 1,     default: false
    t.integer  "current_through_month", limit: 4
    t.integer  "current_through_year",  limit: 4
    t.text     "notes",                 limit: 65535
    t.datetime "member_since"
    t.boolean  "former_member",         limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "share_email",           limit: 1,     default: false
    t.boolean  "share_phone",           limit: 1,     default: false
    t.boolean  "share_address",         limit: 1,     default: false
    t.date     "current_through_date"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "election_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wildwood_registrations", force: :cascade do |t|
    t.integer  "season_id",         limit: 4
    t.string   "name",              limit: 255
    t.string   "address",           limit: 255
    t.string   "city",              limit: 255
    t.string   "state",             limit: 255
    t.string   "zip",               limit: 255
    t.string   "country",           limit: 255
    t.string   "email",             limit: 255
    t.string   "phone",             limit: 255
    t.boolean  "judge",             limit: 1,                             default: false
    t.boolean  "field_staff",       limit: 1,                             default: false
    t.boolean  "sales",             limit: 1,                             default: false
    t.boolean  "workshops",         limit: 1,                             default: false
    t.boolean  "auction",           limit: 1,                             default: false
    t.boolean  "operations",        limit: 1,                             default: false
    t.boolean  "accepted_waiver",   limit: 1,                             default: false
    t.text     "challenges",        limit: 65535
    t.text     "ecskc",             limit: 65535
    t.boolean  "on_site",           limit: 1,                             default: false
    t.integer  "number_for_dinner", limit: 4
    t.decimal  "total_due",                       precision: 6, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
