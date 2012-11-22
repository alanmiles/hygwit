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
#  max_hours_day            :integer          default(9)
#  max_hours_week           :integer          default(45)
#  max_hours_day_ramadan    :integer
#  max_hours_week_ramadan   :integer
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
#

class Country < ActiveRecord::Base
  attr_accessible :country, :currency_id, :insurance, :max_hours_day, :max_hours_week, :max_loan_ded_salary, 
            :nationality_id, :nightwork_end, :nightwork_start, :probation_days, :retirement_age_f, :retirement_age_m, 
            :sickness_accruals, :taxation, :max_hours_day_ramadan, :max_hours_week_ramadan, :OT_rate_standard,
            :OT_rate_special, :notes, :rules, :gratuity_applies, :minimum_vacation_days, :vacation_by_working_days, :created_by
            
  belongs_to :currency
  belongs_to :nationality
  has_many 	 :country_absences, dependent: :destroy
  has_many 	 :country_admins, dependent: :destroy
  
  after_create :add_absence_codes
  
  validates :country,						presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: true }
  validates :nationality_id, 		presence: true
  validates :currency_id,				presence: true
  validates :rules,							length: { maximum: 20, allow_blank: true }
  
  default_scope order: 'countries.country ASC'
  
  def self_ref
    country
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    Country.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Country.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
  def incomplete?
    complete == false
  end
  
  def self.total_incomplete
    Country.where("complete =?", false).count
  end
  
  private
  
    def add_absence_codes
      @absences = AbsenceType.all
      @absences.each do |absence|
        self.country_absences.create(absence_code: absence.absence_code, paid: absence.paid, sickness: absence.sickness,
                                    maximum_days_year: absence.maximum_days_year, 
                                    documentation_required: absence.documentation_required, notes: absence.notes)  
      end         
    end 
end
