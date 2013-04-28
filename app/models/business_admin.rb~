# == Schema Information
#
# Table name: business_admins
#
#  id           :integer          not null, primary key
#  business_id  :integer
#  user_id      :integer
#  created_by   :integer
#  main_contact :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class BusinessAdmin < ActiveRecord::Base
  attr_accessible :business_id, :created_by, :user_id, :main_contact
  
  validates :user_id, 	  		presence: true
  validates :business_id, 		presence: true, uniqueness: { scope: :user_id }
  validates :created_by,			presence: true
end
