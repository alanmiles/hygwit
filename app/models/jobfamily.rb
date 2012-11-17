# == Schema Information
#
# Table name: jobfamilies
#
#  id         :integer          not null, primary key
#  job_family :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Jobfamily < ActiveRecord::Base
  attr_accessible :approved, :created_by, :job_family
  
  validates :job_family, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'jobfamilies.job_family ASC'
  
  def recent?
    approved == false
  end
  
  def self.total_recent
    Jobfamily.where("approved =?", false).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Jobfamily.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
