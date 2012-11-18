# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  contract   :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contract < ActiveRecord::Base
  attr_accessible :contract, :created_by
  
  validates :contract, presence: true, length: { maximum: 25 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'contracts.contract ASC'
  
  def self_ref
    contract
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    Contract.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Contract.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
