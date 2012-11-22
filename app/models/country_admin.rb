# == Schema Information
#
# Table name: country_admins
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CountryAdmin < ActiveRecord::Base
  attr_accessible :country_id, :user_id
  
  belongs_to :user
  belongs_to :country
  
  validates :user_id, 	  	only_admin: true
  validates :country_id, 		presence: true, uniqueness: { scope: :user_id }
  
  def self.total(country)
    self.where("country_id = ?", country).count
  end
  
  def self.all_admins?(country)
    self.total(country) > 1
  end
end
