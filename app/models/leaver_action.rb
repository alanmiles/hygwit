# == Schema Information
#
# Table name: leaver_actions
#
#  id             :integer          not null, primary key
#  action         :string(255)
#  contract       :integer          default(2)
#  residence      :integer          default(2)
#  nationality    :integer          default(2)
#  marital_status :integer          default(2)
#  position       :integer
#  created_by     :integer          default(1)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class LeaverAction < ActiveRecord::Base
  attr_accessible :action, :checked, :contract, :created_by, :marital_status, :nationality, :position, :residence, :updated_by
  acts_as_list
  
  validates :action, 					presence: true, length: { maximum: 50 },
                     					uniqueness: { case_sensitive: false }
  validates :created_by, 			presence: true, numericality: { only_integer: true }
  validates :contract, 				numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :residence, 			numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :nationality, 		numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :marital_status, 	numericality: { only_integer: true }, inclusion: { in: 0..2 }
  
  default_scope order: 'leaver_actions.position ASC'
  
  def self_ref
    action
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end 
  
  def contract_status
    if contract == 0
      return "Contract"
    elsif contract == 1
      return "Non-contract"
    else
      return "Any"
    end
  end
  
  def nationality_status
    if nationality == 0
      return "National"
    elsif nationality == 1
      return "Expat"
    else
      return "Any"
    end
  end
  
  def residence_status
    if residence == 0
      return "Local"
    elsif residence == 1
      return "Overseas"
    else
      return "Any"
    end
  end
  
  def mar_status
    if marital_status == 0
      return "Single"
    elsif marital_status == 1
      return "Married"
    else
      return "Any"
    end
  end
end
