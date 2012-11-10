# == Schema Information
#
# Table name: absence_types
#
#  id                     :integer          not null, primary key
#  absence_code           :string(255)
#  paid                   :integer          default(100)
#  sickness               :boolean          default(FALSE)
#  maximum_days_year      :integer
#  documentation_required :boolean          default(TRUE)
#  notes                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class AbsenceType < ActiveRecord::Base
  attr_accessible :absence_code, :documentation_required, :maximum_days_year, :notes, :paid, :sickness
  
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 0..100, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  
  default_scope order: 'absence_types.absence_code ASC'
end