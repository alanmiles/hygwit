# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  contract   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contract < ActiveRecord::Base
  attr_accessible :contract
  
  validates :contract, presence: true, length: { maximum: 25 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'contracts.contract ASC'
end
