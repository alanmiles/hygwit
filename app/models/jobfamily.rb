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

  attr_accessible :approved, :created_by, :job_family, :checked, :updated_by
  
  validates :job_family, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'jobfamilies.job_family ASC'
  
  def self_ref
    job_family
  end
  
  
end
