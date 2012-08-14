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

ActiveRecord::Schema.define(:version => 20120813233326) do

  create_table "announcements", :force => true do |t|
    t.string   "headline"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "competitors", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "pair",                :default => false
    t.boolean  "team",                :default => false
    t.text     "bio"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "score_multiplier", :default => 1
    t.boolean  "active",           :default => true
    t.integer  "position",         :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "discipline_group"
  end

  create_table "event_details", :force => true do |t|
    t.integer  "event_id"
    t.text     "general_information"
    t.text     "competitor_information"
    t.text     "directions"
    t.text     "accommodations"
    t.text     "banquet"
    t.text     "auction"
    t.text     "sponsors"
    t.text     "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "registration_instructions"
    t.text     "waiver"
  end

  create_table "event_disciplines", :force => true do |t|
    t.integer  "event_id"
    t.integer  "discipline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_registrations", :force => true do |t|
    t.integer  "competitor_id"
    t.integer  "event_id"
    t.decimal  "amount",                :precision => 7, :scale => 2
    t.boolean  "paid",                                                :default => false
    t.boolean  "first_time_competitor",                               :default => false
    t.boolean  "accepted_terms",                                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "volunteer_judge",                                     :default => false
    t.boolean  "volunteer_field_staff",                               :default => false
    t.boolean  "volunteer_setup_crew",                                :default => false
    t.string   "team_member_names"
  end

  create_table "event_sponsors", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "link_type"
    t.text     "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "organizer_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "season_id"
    t.string   "location"
    t.string   "acronym"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "url"
    t.string   "status"
    t.boolean  "fee_received",                   :default => false
    t.boolean  "results_available",              :default => false
    t.boolean  "online_registration",            :default => true
    t.datetime "registration_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration_form_file_name"
    t.string   "registration_form_content_type"
    t.integer  "registration_form_file_size"
    t.datetime "registration_form_updated_at"
  end

  add_index "events", ["season_id"], :name => "index_events_on_season_id"
  add_index "events", ["start_date"], :name => "index_events_on_start_date"

  create_table "jackets", :force => true do |t|
    t.string   "name"
    t.string   "style"
    t.string   "size"
    t.string   "typeface"
    t.integer  "season_id"
    t.boolean  "delivery"
    t.decimal  "price",         :precision => 4, :scale => 2
    t.string   "custom_text_1"
    t.string   "custom_text_2"
    t.string   "custom_text_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.decimal  "amount",           :precision => 8, :scale => 2
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "membership_plans", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",         :precision => 5, :scale => 2
    t.integer  "renewal_period"
    t.boolean  "visible",                                      :default => true
    t.boolean  "primary",                                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "membership_plan_id",                       :null => false
    t.datetime "expires_at"
    t.boolean  "primary_member",        :default => true
    t.integer  "primary_user_id"
    t.integer  "primary_membership_id"
    t.boolean  "paid",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",                        :precision => 8, :scale => 2
    t.string   "state",                                                       :default => "new"
    t.string   "paypal_status"
    t.string   "paypal_transaction_identifier"
    t.decimal  "paypal_fee",                    :precision => 8, :scale => 2
    t.text     "encrypted_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "registration_disciplines", :force => true do |t|
    t.integer  "event_discipline_id"
    t.integer  "event_registration_id"
    t.string   "group_name"
    t.text     "group_members"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "competitor_id"
    t.integer  "event_discipline_id"
    t.decimal  "score"
    t.boolean  "disqualified",        :default => false
    t.integer  "rank"
    t.string   "tie_breaker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
    t.integer  "season_id"
    t.boolean  "current_member",      :default => true
  end

  create_table "seasons", :force => true do |t|
    t.string   "year"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", :force => true do |t|
    t.integer  "competitor_id"
    t.integer  "season_id"
    t.integer  "discipline_id"
    t.integer  "points"
    t.integer  "rank"
    t.integer  "competition_count"
    t.string   "tie_breaker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", :force => true do |t|
    t.integer  "competitor_id"
    t.integer  "team_id"
    t.boolean  "captain",       :default => false
    t.boolean  "sub",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                    :null => false
    t.string   "crypted_password",                         :null => false
    t.string   "password_salt",                            :null => false
    t.string   "persistence_token",                        :null => false
    t.string   "single_access_token",                      :null => false
    t.string   "perishable_token",                         :null => false
    t.integer  "login_count",           :default => 0,     :null => false
    t.integer  "failed_login_count",    :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "full_name"
    t.string   "nickname"
    t.string   "mailing_name"
    t.string   "additional_members"
    t.string   "store_affiliation"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_number"
    t.boolean  "admin",                 :default => false
    t.boolean  "el_member",             :default => false
    t.boolean  "board_member",          :default => false
    t.boolean  "lifetime",              :default => false
    t.integer  "current_through_month"
    t.integer  "current_through_year"
    t.text     "notes"
    t.datetime "member_since"
    t.boolean  "former_member",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "share_email",           :default => false
    t.boolean  "share_phone",           :default => false
    t.boolean  "share_address",         :default => false
    t.date     "current_through_date"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
