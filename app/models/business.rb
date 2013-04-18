# == Schema Information
#
# Table name: businesses
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  country_id            :integer
#  address_1             :string(255)
#  address_2             :string(255)
#  city                  :string(255)
#  sector_id             :integer
#  created_by            :integer
#  updated_by            :integer
#  registration_number   :string(255)
#  bank                  :string(255)      default("(Name of your payroll bank)")
#  bank_branch           :string(255)      default("(Branch identifier)")
#  iban                  :string(255)      default("(Business iban code)")
#  calendar_days         :boolean          default(TRUE)
#  hours_per_day         :decimal(4, 2)    default(8.0)
#  hours_per_month       :decimal(5, 2)    default(160.0)
#  weekend_day_1         :integer          default(6)
#  weekend_day_2         :integer          default(7)
#  standard_ot_rate      :decimal(3, 2)    default(1.25)
#  supplementary_ot_rate :decimal(3, 2)    default(1.5)
#  double_ot_rate        :decimal(3, 2)    default(2.0)
#  standard_start_time   :string(255)      default("08:00")
#  autocalc_benefits     :boolean          default(FALSE)
#  pension_scheme        :boolean          default(FALSE)
#  bonus_provision       :boolean          default(FALSE)
#  close_date            :integer          default(15)
#  last_payroll_date     :date
#  home_airport          :string(255)
#  review_interval       :integer          default(6)
#  setup_complete        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Business < ActiveRecord::Base
  
  attr_accessible :address_1, :address_2, :autocalc_benefits, :bank, :bank_branch, :bonus_provision, :calendar_days, 
                  :city, :close_date, :country_id, :created_by, :double_ot_rate, :home_airport, :hours_per_day, 
                  :hours_per_month, :iban, :last_payroll_date, :name, :pension_scheme, :registration_number, :review_interval, 
                  :sector_id, :setup_complete, :standard_ot_rate, :standard_start_time, :supplementary_ot_rate, :updated_by, 
                  :weekend_day_1, :weekend_day_2
                  
  belongs_to :country
  belongs_to :sector
  #belongs_to :weekday
  
  validates :name, 											presence: true, length: { maximum: 50 },
                     										uniqueness: { case_sensitive: false, scope: :country_id }
  validates :country_id, 								presence: true
  validates :sector_id,									presence: true
  validates :address_1,									length: { maximum: 100, allow_blank: true }
  validates :address_2,									length: { maximum: 100, allow_blank: true }
  validates :city,											length: { maximum: 35, allow_blank: true }
  validates :created_by,								presence: true, numericality: { only_integer: true }
  validates :hours_per_day,							presence: true, numericality: true, inclusion: { in: 1..13 }
  validates :hours_per_month,						presence: true, numericality: true, inclusion: { in: 5..240 }
  validates	:weekend_day_1,							presence: true, numericality: { only_integer: true }, inclusion: { in: 1..7 }
  validates	:weekend_day_2,							presence: true, numericality: { only_integer: true, allow_zero: true }, inclusion: { in: 0..7 }
  validates :registration_number,				length: { maximum: 20, allow_blank: true }
  validates :bank, 											presence: true, length: { maximum: 50 }
  validates :bank_branch, 							presence: true, length: { maximum: 50 }
  validates :iban,				 							presence: true, length: { maximum: 25 }
  validates :standard_ot_rate,					presence: true, numericality: true, inclusion: { in: 0..2 }
  validates :supplementary_ot_rate,			presence: true, numericality: true, inclusion: { in: 0..2 }
  validates :double_ot_rate,					  presence: true, numericality: true, inclusion: { in: 0..3 }
  VALID_STARTTIME_REGEX = /^(20|21|22|23|[01]\d|\d)(([:][0-5]\d){1,2})$/
  validates :standard_start_time,				presence: true, format: { with: VALID_STARTTIME_REGEX }
  validates :close_date,								presence: true, numericality: { only_integer: true }, inclusion: { in: 10..27 }
  validates :home_airport, 							length: { maximum: 35, allow_blank: true }
  validates :review_interval,						presence: true, numericality: { only_integer: true }, inclusion: { in: 1..12 }
  
end
