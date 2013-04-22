# == Schema Information
#
# Table name: contract_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  contract    :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ContractCat < ActiveRecord::Base
  attr_accessible :contract, :created_by, :updated_by
  
  belongs_to :business
  
  validates :business_id,		presence: true
  validates :contract, 			presence: true, length: { maximum: 25 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'contract_cats.contract ASC'
end
