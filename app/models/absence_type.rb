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
#  checked                :boolean          default(FALSE)
#  updated_by             :integer          default(1)
#

class AbsenceType < ActiveRecord::Base

  include UpdateCheck
  
  attr_accessible :absence_code, :documentation_required, :maximum_days_year, :notes, :paid, :sickness, :checked, :updated_by, :created_by
  
  validates :absence_code,		  presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: true }
  validates :paid,							presence: true, numericality: { only_integer: true }, inclusion: 0..100
  validates :maximum_days_year,	inclusion: { in: 0..365, allow_nil: true }, numericality: { only_integer: true, allow_nil: true }
  validates :notes,							length: { maximum: 140 }
  validates :created_by,				presence: true
  
  default_scope order: 'absence_types.absence_code ASC'
  
  def self_ref
    absence_code
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.all_recent
    self.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.all_updated
    self.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def self.added_require_checks
    self.where("checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", false).count
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def self.updated_require_checks
    self.where("checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", false).count
  end 
end
