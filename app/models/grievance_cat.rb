# == Schema Information
#
# Table name: grievance_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  grievance   :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GrievanceCat < ActiveRecord::Base
  attr_accessible :created_by, :grievance, :updated_by
  
  belongs_to :business
  
  validates :business_id,		presence: true
  validates :grievance, 		presence: true, length: { maximum: 50 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'grievance_cats.grievance ASC'
end
