# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  contract   :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class Contract < ActiveRecord::Base

  attr_accessible :contract, :created_by, :updated_by, :checked
  
  validates :contract, presence: true, length: { maximum: 25 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, 		presence: true                   
  
                     
  default_scope order: 'contracts.contract ASC'
  
  def self_ref
    contract
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end 
  
end
