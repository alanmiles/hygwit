# == Schema Information
#
# Table name: countries
#
#  id                       :integer          not null, primary key
#  country                  :string(255)
#  nationality_id           :integer
#  currency_id              :integer
#  taxation                 :boolean          default(FALSE)
#  insurance                :boolean          default(TRUE)
#  probation_days           :integer          default(90)
#  max_hours_day            :decimal(, )      default(9.0)
#  max_hours_week           :decimal(, )      default(45.0)
#  max_hours_day_ramadan    :decimal(, )
#  max_hours_week_ramadan   :decimal(, )
#  sickness_accruals        :boolean          default(FALSE)
#  retirement_age_m         :integer          default(60)
#  retirement_age_f         :integer          default(55)
#  OT_rate_standard         :decimal(3, 2)
#  OT_rate_special          :decimal(3, 2)
#  nightwork_start          :time
#  nightwork_end            :time
#  max_loan_ded_salary      :integer          default(15)
#  notes                    :text
#  complete                 :boolean          default(FALSE)
#  created_by               :integer          default(1)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rules                    :string(255)
#  gratuity_applies         :boolean          default(FALSE)
#  minimum_vacation_days    :integer          default(21)
#  vacation_by_working_days :boolean          default(FALSE)
#  gratuity_ceiling_months  :integer
#  gratuity_ceiling_value   :integer
#  checked                  :boolean          default(FALSE)
#  updated_by               :integer          default(1)
#  ethnicity_reports        :boolean          default(FALSE)
#  ethnicity_details        :text
#  reserved_jobs            :boolean          default(FALSE)
#  disability_rules         :boolean          default(FALSE)
#  disability_details       :text
#  test_code                :string(255)
#  test_salary              :decimal(, )
#  test_date                :date
#  test_result              :decimal(, )
#  test_result_2            :decimal(, )
#

class Country < ActiveRecord::Base
  
  attr_accessible :country, :currency_id, :insurance, :max_hours_day, :max_hours_week, :max_loan_ded_salary, 
            :nationality_id, :nightwork_end, :nightwork_start, :probation_days, :retirement_age_f, :retirement_age_m, 
            :sickness_accruals, :taxation, :max_hours_day_ramadan, :max_hours_week_ramadan, :OT_rate_standard,
            :OT_rate_special, :notes, :rules, :gratuity_applies, :minimum_vacation_days, :vacation_by_working_days, :created_by, 
            :gratuity_ceiling_months, :gratuity_ceiling_value, :complete, :checked, :updated_by, :ethnicity_reports, 
            :ethnicity_details, :reserved_jobs, :disability_rules, :disability_details
            
  belongs_to :currency
  belongs_to :nationality
  has_many 	 :country_absences, dependent: :destroy
  has_many 	 :country_admins, dependent: :destroy
  has_many   :holidays, dependent: :destroy
  has_many	 :gratuity_formulas, dependent: :destroy
  has_many   :insurance_settings, dependent: :destroy
  has_many 	 :insurance_codes, dependent: :destroy
  has_many   :insurance_rates, dependent: :destroy
  has_many   :ethnic_groups, dependent: :destroy
  has_many   :reserved_occupations, dependent: :destroy
  has_many	 :businesses
  
  
  after_create :add_absence_codes
  
  validates :country,										presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: true }
  validates :nationality_id, 						presence: true
  validates :currency_id,								presence: true
  validates :rules,											length: { maximum: 20, allow_blank: true }
  validates :max_hours_day,							numericality: true
  validates :max_hours_week,						numericality: true
  validates :max_hours_day_ramadan,			numericality: { allow_nil: true }
  validates :max_hours_week_ramadan,		numericality: { allow_nil: true }
  validates :gratuity_ceiling_months,		numericality: { only_integer: true, allow_nil: true }
  validates :gratuity_ceiling_value,		numericality: { only_integer: true, allow_nil: true }
  validate  :gratuity_ceiling_check
  
  default_scope order: 'countries.country ASC'
  
  def self_ref
    country
  end
  
  def incomplete?
    complete == false
  end
  
  def self.total_incomplete
    Country.where("complete =?", false).count
  end
  
  def home_currency
    currency.code
  end
  
  def insurance_empty?
    self.insurance_codes.count == 0 || self.insurance_settings.count == 0
  end
  
  def recalculate_ni_rates(e_date, user)
    @codes = self.insurance_codes.where("cancelled IS NULL or date(cancelled) > ?", e_date) 
    @settings = self.insurance_settings.snapshot_list(e_date)
    @codes.each do |code|
      @seq = 1
      @settings.each do |setting|
        unless setting == @settings.last
          @next_setting = @settings.fetch(@seq)
          self.insurance_rates.create(insurance_code_id: code, threshold_id: setting.id, ceiling_id: @next_setting.id,
                   contribution: 10, created_by: user, updated_by: user, effective: e_date)
          self.insurance_rates.create(insurance_code_id: code, threshold_id: setting.id, ceiling_id: @next_setting.id,
                   contribution: 10, source_employee: false, created_by: user, updated_by: user, effective: e_date)
        else
          self.insurance_rates.create(insurance_code_id: code, threshold_id: setting.id,
                   contribution: 10, created_by: user, updated_by: user, effective: e_date)
          self.insurance_rates.create(insurance_code_id: code, threshold_id: setting.id,
                   contribution: 10, source_employee: false, created_by: user, updated_by: user, effective: e_date)
        end
        @seq = @seq + 1
      end
    end
  end
  
  def self.ready_to_use
    self.where("complete = ?", true)
  end
  
  def checked_absences
    self.country_absences.where("checked = ?", true)
  end
   
  private
  
    def add_absence_codes
      @absences = AbsenceType.all_checked
      @absences.each do |absence|
        self.country_absences.create(absence_code: absence.absence_code, paid: absence.paid, sickness: absence.sickness,
                                    maximum_days_year: absence.maximum_days_year, 
                                    documentation_required: absence.documentation_required, notes: absence.notes, 
                                    checked: absence.checked)  
      end         
    end
    
    def gratuity_ceiling_check
      unless gratuity_applies?
        unless gratuity_ceiling_months.nil? && gratuity_ceiling_value.nil?
          errors[:base] << "Before you can turn 'Gratuity applies' off, you first need to remove the values for gratuity ceilings"
        end
      end
    end 
end
