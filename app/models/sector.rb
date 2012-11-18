# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  sector     :string(255)
#  created_by :integer          default(1)
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sector < ActiveRecord::Base

  attr_accessible :approved, :sector, :created_by
  
  validates :sector, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'sectors.sector ASC'
  
  def self_ref
    sector
  end
  
  def recent?
    approved == false
  end
  
  def self.total_recent
    Sector.where("approved =?", false).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Sector.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
