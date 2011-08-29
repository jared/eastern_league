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

ActiveRecord::Schema.define(:version => 20110828143118) do

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
    t.integer  "user_id",                               :null => false
    t.integer  "membership_plan_id",                    :null => false
    t.datetime "expires_at"
    t.boolean  "primary_member",     :default => true
    t.integer  "primary_user_id"
    t.boolean  "paid",               :default => false
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
    t.string   "last_name"
    t.string   "first_name"
    t.string   "full_name"
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
  end

end
