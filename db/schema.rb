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

ActiveRecord::Schema.define(:version => 20121105194738) do

  create_table "countries", :force => true do |t|
    t.string   "country"
    t.integer  "nationality_id"
    t.integer  "currency_id"
    t.boolean  "taxation",                                             :default => false
    t.boolean  "insurance",                                            :default => true
    t.integer  "probation_days",                                       :default => 90
    t.integer  "max_hours_day",                                        :default => 9
    t.integer  "max_hours_week",                                       :default => 45
    t.integer  "max_hours_day_ramadan",                                :default => 6
    t.integer  "max_hours_week_ramadan",                               :default => 30
    t.boolean  "sickness_accruals",                                    :default => false
    t.integer  "retirement_age_m",                                     :default => 60
    t.integer  "retirement_age_f",                                     :default => 55
    t.decimal  "OT_rate_standard",       :precision => 3, :scale => 2
    t.decimal  "OT_rate_special",        :precision => 3, :scale => 2
    t.time     "nightwork_start"
    t.time     "nightwork_end"
    t.integer  "max_loan_ded_salary",                                  :default => 15
    t.text     "notes"
    t.boolean  "complete",                                             :default => false
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
  end

  create_table "currencies", :force => true do |t|
    t.string   "currency"
    t.string   "code"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "decimal_places", :default => 2
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code"

  create_table "nationalities", :force => true do |t|
    t.string   "nationality"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "nationalities", ["nationality"], :name => "index_nationalities_on_nationality"

  create_table "sectors", :force => true do |t|
    t.string   "sector"
    t.integer  "created_by"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
