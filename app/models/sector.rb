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
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class Sector < ActiveRecord::Base

  attr_accessible :sector, :checked, :updated_by, :created_by
  
  has_many :businesses
  
  validates :sector, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'sectors.sector ASC'
  
  def self_ref
    sector
  end
  
  def self.ready_to_use
    self.where("checked =?", true)
  end
  
end
