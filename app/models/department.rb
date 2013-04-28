# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  business_id :integer
#  department  :string(255)
#  dept_code   :string(255)
#  division_id :integer
#  current     :boolean          default(TRUE)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Department < ActiveRecord::Base
  attr_accessible :created_by, :current, :department, :dept_code, :division_id, :updated_by
  
  belongs_to :business
  belongs_to :division
  has_many :jobs
  
  validates :business_id,					presence: true
  validates :department,				  presence: true, length: { maximum: 25 }, 
  																	uniqueness: { case_sensitive: false, scope: :business_id }
  validates :dept_code, 				  presence: true, length: { maximum: 4 }, 
  																	uniqueness: { case_sensitive: false, scope: :business_id }
  validates :division_id,					numericality: { only_integer: true, allow_nil: true }												
end
