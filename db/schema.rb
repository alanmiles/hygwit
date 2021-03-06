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

ActiveRecord::Schema.define(:version => 20130506065915) do

  create_table "absence_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "absence_code"
    t.integer  "paid",                   :default => 100
    t.boolean  "sickness",               :default => false
    t.integer  "maximum_days_year"
    t.boolean  "documentation_required", :default => true
    t.string   "notes"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "current",                :default => true
  end

  add_index "absence_cats", ["business_id", "absence_code", "sickness"], :name => "index_absence_cats_on_business_id_and_absence_code_and_sickness"

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
    t.boolean  "checked",                :default => false
    t.integer  "updated_by",             :default => 1
  end

  create_table "advance_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "name"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "advance_cats", ["business_id", "name"], :name => "index_advance_cats_on_business_id_and_name"

  create_table "advance_types", :force => true do |t|
    t.string   "name"
    t.integer  "created_by", :default => 1
    t.boolean  "checked",    :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "business_admins", :force => true do |t|
    t.integer  "business_id"
    t.integer  "user_id"
    t.integer  "created_by"
    t.boolean  "main_contact", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "manager",      :default => false
    t.boolean  "staff",        :default => false
    t.boolean  "payroll",      :default => false
    t.boolean  "attendance",   :default => false
    t.boolean  "recruitment",  :default => false
    t.boolean  "performance",  :default => false
    t.boolean  "training",     :default => false
    t.boolean  "property",     :default => false
    t.boolean  "pro",          :default => false
  end

  add_index "business_admins", ["business_id"], :name => "index_business_admins_on_business_id"
  add_index "business_admins", ["user_id"], :name => "index_business_admins_on_user_id"

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.integer  "sector_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "registration_number"
    t.string   "bank",                                                :default => "(Name of your payroll bank)"
    t.string   "bank_branch",                                         :default => "(Branch identifier)"
    t.string   "iban",                                                :default => "(Business iban code)"
    t.boolean  "calendar_days",                                       :default => true
    t.decimal  "hours_per_day",         :precision => 4, :scale => 2, :default => 8.0
    t.decimal  "hours_per_month",       :precision => 5, :scale => 2, :default => 160.0
    t.integer  "weekend_day_1",                                       :default => 6
    t.integer  "weekend_day_2",                                       :default => 7
    t.decimal  "standard_ot_rate",      :precision => 3, :scale => 2, :default => 1.25
    t.decimal  "supplementary_ot_rate", :precision => 3, :scale => 2, :default => 1.5
    t.decimal  "double_ot_rate",        :precision => 3, :scale => 2, :default => 2.0
    t.string   "standard_start_time",                                 :default => "08:00"
    t.boolean  "autocalc_benefits",                                   :default => false
    t.boolean  "pension_scheme",                                      :default => false
    t.boolean  "bonus_provision",                                     :default => false
    t.integer  "close_date",                                          :default => 15
    t.date     "last_payroll_date"
    t.string   "home_airport"
    t.integer  "review_interval",                                     :default => 6
    t.boolean  "setup_complete",                                      :default => false
    t.datetime "created_at",                                                                                     :null => false
    t.datetime "updated_at",                                                                                     :null => false
  end

  create_table "contract_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "contract"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "contract_cats", ["business_id", "contract"], :name => "index_contract_cats_on_business_id_and_contract"

  create_table "contracts", :force => true do |t|
    t.string   "contract"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
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
    t.boolean  "ethnicity_reports",                                      :default => false
    t.text     "ethnicity_details"
    t.boolean  "reserved_jobs",                                          :default => false
    t.boolean  "disability_rules",                                       :default => false
    t.text     "disability_details"
    t.string   "test_code"
    t.decimal  "test_salary"
    t.date     "test_date"
    t.decimal  "test_result"
    t.decimal  "test_result_2"
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

  create_table "departments", :force => true do |t|
    t.integer  "business_id"
    t.string   "department"
    t.string   "dept_code"
    t.integer  "division_id"
    t.boolean  "current",     :default => true
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "departments", ["business_id", "department"], :name => "index_departments_on_business_id_and_department"
  add_index "departments", ["division_id", "department"], :name => "index_departments_on_division_id_and_department"

  create_table "descriptors", :force => true do |t|
    t.integer  "quality_id"
    t.string   "grade"
    t.string   "descriptor"
    t.boolean  "reviewed",   :default => false
    t.integer  "updated_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
  end

  create_table "disciplinary_categories", :force => true do |t|
    t.string   "category"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
  end

  create_table "disciplinary_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "category"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "disciplinary_cats", ["business_id", "category"], :name => "index_disciplinary_cats_on_business_id_and_category"

  create_table "divisions", :force => true do |t|
    t.integer  "business_id"
    t.string   "division"
    t.boolean  "current",     :default => true
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "divisions", ["business_id", "division"], :name => "index_divisions_on_business_id_and_division"

  create_table "ethnic_groups", :force => true do |t|
    t.integer  "country_id"
    t.string   "ethnic_group"
    t.boolean  "checked",           :default => false
    t.integer  "created_by",        :default => 1
    t.integer  "updated_by",        :default => 1
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.date     "cancellation_date"
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
    t.integer  "created_by",                                           :default => 1
  end

  create_table "grievance_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "grievance"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "grievance_cats", ["business_id", "grievance"], :name => "index_grievance_cats_on_business_id_and_grievance"

  create_table "grievance_types", :force => true do |t|
    t.string   "grievance"
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
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
    t.integer  "created_by", :default => 1
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
    t.integer  "created_by",     :default => 1
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

  create_table "insurance_rates", :force => true do |t|
    t.integer  "country_id"
    t.integer  "insurance_code_id"
    t.boolean  "source_employee",   :default => true
    t.integer  "threshold_id"
    t.integer  "ceiling_id"
    t.decimal  "contribution"
    t.boolean  "percent",           :default => true
    t.boolean  "rebate",            :default => false
    t.integer  "created_by",        :default => 1
    t.integer  "updated_by",        :default => 1
    t.boolean  "checked",           :default => false
    t.date     "effective"
    t.date     "cancellation"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "insurance_settings", :force => true do |t|
    t.integer  "country_id"
    t.string   "shortcode"
    t.string   "name"
    t.decimal  "weekly_milestone"
    t.decimal  "monthly_milestone"
    t.decimal  "annual_milestone"
    t.date     "effective_date"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "cancellation_date"
    t.boolean  "checked",             :default => false
    t.integer  "updated_by",          :default => 1
    t.integer  "created_by",          :default => 1
    t.boolean  "cancellation_change", :default => false
  end

  create_table "jobfamilies", :force => true do |t|
    t.string   "job_family"
    t.boolean  "approved",   :default => false
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
  end

  create_table "jobs", :force => true do |t|
    t.integer  "business_id"
    t.integer  "department_id"
    t.string   "job_title"
    t.integer  "jobfamily_id"
    t.integer  "rank_cat_id"
    t.integer  "positions",     :default => 1
    t.boolean  "current",       :default => true
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "jobs", ["business_id", "department_id", "job_title"], :name => "index_jobs_on_business_id_and_department_id_and_job_title", :unique => true
  add_index "jobs", ["jobfamily_id"], :name => "index_jobs_on_jobfamily_id"
  add_index "jobs", ["rank_cat_id"], :name => "index_jobs_on_rank_cat_id"

  create_table "joiner_actions", :force => true do |t|
    t.string   "action"
    t.integer  "contract",       :default => 2
    t.integer  "residence",      :default => 2
    t.integer  "nationality",    :default => 2
    t.integer  "marital_status", :default => 2
    t.integer  "position"
    t.integer  "created_by",     :default => 1
    t.boolean  "checked",        :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "joiner_activities", :force => true do |t|
    t.integer  "business_id"
    t.string   "action"
    t.integer  "contract",       :default => 2
    t.integer  "residence",      :default => 2
    t.integer  "nationality",    :default => 2
    t.integer  "marital_status", :default => 2
    t.integer  "position"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "joiner_activities", ["business_id", "action"], :name => "index_joiner_activities_on_business_id_and_action"

  create_table "leaver_actions", :force => true do |t|
    t.string   "action"
    t.integer  "contract",       :default => 2
    t.integer  "residence",      :default => 2
    t.integer  "nationality",    :default => 2
    t.integer  "marital_status", :default => 2
    t.integer  "position"
    t.integer  "created_by",     :default => 1
    t.boolean  "checked",        :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "leaver_activities", :force => true do |t|
    t.integer  "business_id"
    t.string   "action"
    t.integer  "position"
    t.integer  "contract",       :default => 2
    t.integer  "residence",      :default => 2
    t.integer  "nationality",    :default => 2
    t.integer  "marital_status", :default => 2
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "leaver_activities", ["business_id", "action"], :name => "index_leaver_activities_on_business_id_and_action"

  create_table "leaving_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "reason"
    t.boolean  "full_benefits", :default => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "leaving_cats", ["business_id", "reason"], :name => "index_leaving_cats_on_business_id_and_reason"

  create_table "leaving_reasons", :force => true do |t|
    t.string   "reason"
    t.boolean  "full_benefits", :default => false
    t.integer  "created_by",    :default => 1
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "checked",       :default => false
    t.integer  "updated_by",    :default => 1
  end

  create_table "loan_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "name"
    t.integer  "qualifying_months",                                   :default => 12
    t.integer  "max_repayment_months",                                :default => 12
    t.integer  "max_salary_multiplier",                               :default => 12
    t.integer  "max_amount",                                          :default => 1000
    t.decimal  "apr",                   :precision => 4, :scale => 2, :default => 0.0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
  end

  add_index "loan_cats", ["business_id", "name"], :name => "index_loan_cats_on_business_id_and_name"

  create_table "loan_types", :force => true do |t|
    t.string   "name"
    t.integer  "qualifying_months",                                   :default => 12
    t.integer  "max_repayment_months",                                :default => 12
    t.integer  "max_salary_multiplier",                               :default => 12
    t.integer  "max_amount",                                          :default => 1000
    t.decimal  "apr",                   :precision => 4, :scale => 2, :default => 0.0
    t.integer  "created_by",                                          :default => 1
    t.boolean  "checked",                                             :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
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

  create_table "pay_categories", :force => true do |t|
    t.string   "category"
    t.string   "description"
    t.boolean  "on_payslip",  :default => false
    t.integer  "created_by",  :default => 1
    t.boolean  "checked",     :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "position"
  end

  create_table "pay_items", :force => true do |t|
    t.string   "item"
    t.integer  "pay_category_id"
    t.string   "short_name"
    t.boolean  "deduction",       :default => false
    t.boolean  "taxable",         :default => false
    t.boolean  "fixed",           :default => false
    t.integer  "position"
    t.integer  "created_by",      :default => 1
    t.boolean  "checked",         :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "payroll_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "category"
    t.string   "description"
    t.boolean  "on_payslip",  :default => false
    t.integer  "position"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "payroll_cats", ["business_id", "category"], :name => "index_payroll_cats_on_business_id_and_category"

  create_table "payroll_items", :force => true do |t|
    t.integer  "business_id"
    t.string   "item"
    t.integer  "payroll_cat_id"
    t.string   "short_name"
    t.boolean  "deduction",      :default => false
    t.boolean  "gross_salary",   :default => false
    t.boolean  "fixed",          :default => false
    t.integer  "position"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "payroll_items", ["business_id", "payroll_cat_id", "item"], :name => "index_payroll_items_on_business_id_and_payroll_cat_id_and_item"

  create_table "personal_qualities", :force => true do |t|
    t.integer  "business_id"
    t.string   "quality"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "personal_qualities", ["business_id", "quality"], :name => "index_personal_qualities_on_business_id_and_quality"

  create_table "qualities", :force => true do |t|
    t.string   "quality"
    t.boolean  "approved",   :default => false
    t.integer  "created_by", :default => 1
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "checked",    :default => false
    t.integer  "updated_by", :default => 1
  end

  create_table "quality_descriptors", :force => true do |t|
    t.integer  "personal_quality_id"
    t.string   "grade"
    t.string   "descriptor"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "quality_descriptors", ["personal_quality_id", "grade"], :name => "index_quality_descriptors_on_personal_quality_id_and_grade"

  create_table "rank_cats", :force => true do |t|
    t.integer  "business_id"
    t.string   "rank"
    t.integer  "position"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "rank_cats", ["business_id", "rank"], :name => "index_rank_cats_on_business_id_and_rank"

  create_table "ranks", :force => true do |t|
    t.string   "rank"
    t.integer  "position"
    t.integer  "created_by", :default => 1
    t.boolean  "checked",    :default => false
    t.integer  "updated_by"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "reserved_occupations", :force => true do |t|
    t.integer  "country_id"
    t.integer  "jobfamily_id"
    t.boolean  "checked",      :default => false
    t.integer  "created_by",   :default => 1
    t.integer  "updated_by",   :default => 1
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
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

  create_table "weekdays", :force => true do |t|
    t.string   "day"
    t.string   "abbreviation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
