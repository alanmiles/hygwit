# == Schema Information
#
# Table name: countries
#
#  id                     :integer          not null, primary key
#  country                :string(255)
#  nationality_id         :integer
#  currency_id            :integer
#  taxation               :boolean          default(FALSE)
#  insurance              :boolean          default(TRUE)
#  probation_days         :integer          default(90)
#  max_hours_day          :integer          default(9)
#  max_hours_week         :integer          default(45)
#  max_hours_day_ramadan  :integer          default(6)
#  max_hours_week_ramadan :integer          default(30)
#  sickness_accruals      :boolean          default(FALSE)
#  retirement_age_m       :integer          default(60)
#  retirement_age_f       :integer          default(55)
#  OT_rate_standard       :decimal(3, 2)
#  OT_rate_special        :decimal(3, 2)
#  nightwork_start        :time
#  nightwork_end          :time
#  max_loan_ded_salary    :integer          default(15)
#  notes                  :text
#  complete               :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Country < ActiveRecord::Base
  attr_accessible :country, :currency_id, :insurance, :max_hours_day, :max_hours_week, :max_loan_ded_salary, 
            :nationality_id, :nightwork_end, :nightwork_start, :probation_days, :retirement_age_f, :retirement_age_m, 
            :sickness_accruals, :taxation, :max_hours_day_ramadan, :max_hours_week_ramadan, :OT_rate_standard,
            :OT_rate_special, :notes
            
  belongs_to :currency
  belongs_to :nationality
  
  validates :country,						presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: true }
  validates :nationality_id, 		presence: true
  validates :currency_id,				presence: true
  
  def taxation_status
    if taxation?
      "Yes"
    else
      "No"
    end
  end
  
  def insurance_status
    if insurance?
      "Yes"
    else
      "No"
    end
  end
  
  
end
