# == Schema Information
#
# Table name: leaving_cats
#
#  id            :integer          not null, primary key
#  business_id   :integer
#  reason        :string(255)
#  full_benefits :boolean          default(FALSE)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LeavingCat < ActiveRecord::Base
  attr_accessible :created_by, :full_benefits, :reason, :updated_by
  
  belongs_to :business
  
  validates :business_id,		presence: true
  validates :reason, 				presence: true, length: { maximum: 25 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'leaving_cats.reason ASC'
end
