# == Schema Information
#
# Table name: country_absences
#
#  id                     :integer          not null, primary key
#  country_id             :integer
#  absence_code           :string(255)
#  paid                   :integer          default(100)
#  sickness               :boolean          default(FALSE)
#  maximum_days_year      :integer
#  documentation_required :boolean          default(TRUE)
#  notes                  :string(255)
#  created_by             :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  checked                :boolean          default(FALSE)
#  updated_by             :integer          default(1)
#

class CountryAbsence < ActiveRecord::Base

  attr_accessible :absence_code, :documentation_required, :maximum_days_year, :notes, :paid, :sickness, :created_by, :updated_by, :checked
  
  belongs_to :country
  
  before_save	:upcase_absence
  
  validates :country_id,				presence: true
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true, scope: :country_id }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 1..100, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  
  default_scope order: 'country_absences.absence_code ASC'
  
  private
  
    def upcase_absence
      absence_code.upcase!
    end
end
