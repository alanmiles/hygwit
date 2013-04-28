# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  department_id :integer
#  job_title     :string(255)
#  jobfamily_id  :integer
#  positions     :integer          default(1)
#  current       :boolean          default(TRUE)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Job < ActiveRecord::Base
  attr_accessible :created_by, :current, :job_title, :jobfamily_id, :updated_by, :positions
  
  belongs_to :department
  belongs_to :jobfamily
  
  validates :department_id,				presence: true
  validates :jobfamily_id,				presence: true
  validates :job_title,				  	presence: true, length: { maximum: 50 }, 
  																	uniqueness: { case_sensitive: false, scope: :department_id }
  validates :positions, 				  presence: true, numericality: { only_integer: true }, 
  																	inclusion: { in: 0..1000 }
  	
end
