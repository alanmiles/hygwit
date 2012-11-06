# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  sector     :string(255)
#  created_by :integer
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sector < ActiveRecord::Base

  attr_accessible :approved, :sector, :created_by
  
  validates :sector, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
end
