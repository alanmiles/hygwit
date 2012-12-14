# == Schema Information
#
# Table name: reserved_occupations
#
#  id           :integer          not null, primary key
#  country_id   :integer
#  jobfamily_id :integer
#  checked      :boolean          default(FALSE)
#  created_by   :integer          default(1)
#  updated_by   :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ReservedOccupation < ActiveRecord::Base
  attr_accessible :checked, :created_by, :jobfamily_id, :updated_by, :country_id
  
  belongs_to :country
  belongs_to :jobfamily
  
  validates :country_id, 			presence: true
  validates :jobfamily_id,		presence: true, uniqueness: { scope: :country_id }
  
end
