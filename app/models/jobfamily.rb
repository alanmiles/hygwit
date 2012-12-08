# == Schema Information
#
# Table name: jobfamilies
#
#  id         :integer          not null, primary key
#  job_family :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class Jobfamily < ActiveRecord::Base

  include UpdateCheck

  attr_accessible :approved, :created_by, :job_family, :checked, :updated_by
  
  validates :job_family, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'jobfamilies.job_family ASC'
  
  def self_ref
    job_family
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
