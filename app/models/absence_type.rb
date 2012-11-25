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
#  created_by             :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class AbsenceType < ActiveRecord::Base
  attr_accessible :absence_code, :documentation_required, :maximum_days_year, :notes, :paid, :sickness, :created_by
  
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 0..365, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  
  default_scope order: 'absence_types.absence_code ASC'
  
  def self_ref
    absence_code
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    AbsenceType.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    AbsenceType.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
