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
end
