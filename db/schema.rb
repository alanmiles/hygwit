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

ActiveRecord::Schema.define(:version => 20121207125314) do

  create_table "absence_types", :force => true do |t|
    t.string   "absence_code"
    t.integer  "paid",                   :default => 100
    t.boolean  "sickness",               :default => false
    t.integer  "maximum_days_year"
    t.boolean  "documentation_required", :default => true
    t.string   "notes"
    t.integer  "created_by",             :default => 1
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "contracts", :force => true do |t|
    t.string   "contract"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "country"
    t.integer  "nationality_id"
    t.integer  "currency_id"
    t.boolean  "taxation",                                               :default => false
    t.boolean  "insurance",                                              :default => true
    t.integer  "probation_days",                                         :default => 90
    t.decimal  "max_hours_day",                                          :default => 9.0
    t.decimal  "max_hours_week",                                         :default => 45.0
    t.decimal  "max_hours_day_ramadan"
    t.decimal  "max_hours_week_ramadan"
    t.boolean  "sickness_accruals",                                      :default => false
    t.integer  "retirement_age_m",                                       :default => 60
    t.integer  "retirement_age_f",                                       :default => 55
    t.decimal  "OT_rate_standard",         :precision => 3, :scale => 2
    t.decimal  "OT_rate_special",          :precision => 3, :scale => 2
    t.time     "nightwork_start"
    t.time     "nightwork_end"
    t.integer  "max_loan_ded_salary",                                    :default => 15
    t.text     "notes"
    t.boolean  "complete",                                               :default => false
    t.integer  "created_by",                                             :default => 1
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "rules"
    t.boolean  "gratuity_applies",                                       :default => false
    t.integer  "minimum_vacation_days",                                  :default => 21
    t.boolean  "vacation_by_working_days",                               :default => false
    t.integer  "gratuity_ceiling_months"
    t.decimal  "gratuity_ceiling_value",   :precision => 7, :scale => 0
    t.boolean  "checked",                                                :default => false
    t.integer  "updated_by",                                             :default => 1
  end

  create_table "country_absences", :force => true do |t|
    t.integer  "country_id"
    t.string   "absence_code"
    t.integer  "paid",                   :default => 100
    t.boolean  "sickness",               :default => false
    t.integer  "maximum_days_year"
    t.boolean  "documentation_required", :default => true
    t.string   "notes"
    t.integer  "created_by",             :default => 1
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "checked",                :default => false
    t.integer  "updated_by",             :default => 1
  end

  create_table "country_admins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "currencies", :force => true do |t|
    t.string   "currency"
    t.string   "code"
    t.integer  "created_by",     :default => 1
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "decimal_places", :default => 2
    t.boolean  "checked",        :default => false
    t.integer  "updated_by",     :default => 1
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code"

  create_table "descriptors", :force => true do |t|
    t.integer  "quality_id"
    t.string   "grade"
    t.string   "descriptor"
    t.boolean  "reviewed",   :default => false
    t.integer  "updated_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "disciplinary_categories", :force => true do |t|
    t.string   "category"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "gratuity_formulas", :force => true do |t|
    t.integer  "country_id"
    t.integer  "service_years_from"
    t.integer  "service_years_to"
    t.decimal  "termination_percentage", :precision => 5, :scale => 2
    t.decimal  "resignation_percentage", :precision => 5, :scale => 2
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.boolean  "checked",                                              :default => false
    t.integer  "updated_by",                                           :default => 1
  end

  create_table "grievance_types", :force => true do |t|
    t.string   "grievance"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "holidays", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
  end

  create_table "insurance_codes", :force => true do |t|
    t.integer  "country_id"
    t.string   "insurance_code"
    t.string   "explanation"
    t.boolean  "checked",        :default => false
    t.integer  "updated_by",     :default => 1
    t.date     "cancelled"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "insurance_formulas", :force => true do |t|
    t.integer  "country_id"
    t.integer  "minimum_salary"
    t.integer  "maximum_salary"
    t.decimal  "employer_contribution",       :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "employee_contribution",       :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "employer_contribution_expat", :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "employee_contribution_expat", :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
  end

  create_table "insurance_settings", :force => true do |t|
    t.integer  "country_id"
    t.string   "shortcode"
    t.string   "name"
    t.decimal  "weekly_milestone"
    t.decimal  "monthly_milestone"
    t.decimal  "annual_milestone"
    t.date     "effective_date"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.date     "cancellation_date"
    t.boolean  "checked",           :default => false
    t.integer  "updated_by",        :default => 1
  end

  create_table "jobfamilies", :force => true do |t|
    t.string   "job_family"
    t.boolean  "approved",   :default => false
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "leaving_reasons", :force => true do |t|
    t.string   "reason"
    t.boolean  "full_benefits", :default => false
    t.integer  "created_by",    :default => 1
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "nationalities", :force => true do |t|
    t.string   "nationality"
    t.integer  "created_by",  :default => 1
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "checked",     :default => false
    t.integer  "updated_by",  :default => 1
  end

  add_index "nationalities", ["nationality"], :name => "index_nationalities_on_nationality"

  create_table "qualities", :force => true do |t|
    t.string   "quality"
    t.boolean  "approved",   :default => false
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "sectors", :force => true do |t|
    t.string   "sector"
    t.integer  "created_by", :default => 1
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.boolean  "superuser",              :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
