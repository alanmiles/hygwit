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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class CountryAbsence < ActiveRecord::Base
  attr_accessible :absence_code, :documentation_required, :maximum_days_year, :notes, :paid, :sickness
  
  belongs_to :country
  
  validates :country_id,				presence: true
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true, scope: :country_id }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 0..100, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  
  default_scope order: 'country_absences.absence_code ASC'
end
