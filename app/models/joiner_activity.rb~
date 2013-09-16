# == Schema Information
#
# Table name: joiner_activities
#
#  id             :integer          not null, primary key
#  business_id    :integer
#  action         :string(255)
#  contract       :integer          default(2)
#  residence      :integer          default(2)
#  nationality    :integer          default(2)
#  marital_status :integer          default(2)
#  position       :integer
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class JoinerActivity < ActiveRecord::Base
  attr_accessible :action, :contract, :created_by, :marital_status, :nationality, :position, :residence, :updated_by
  acts_as_list
  
  belongs_to :business
  
  validates :business_id,			presence: true
  validates :action, 					presence: true, length: { maximum: 50 },
                     					uniqueness: { case_sensitive: false, scope: :business_id }
  validates :contract, 				numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :residence, 			numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :nationality, 		numericality: { only_integer: true }, inclusion: { in: 0..2 }
  validates :marital_status, 	numericality: { only_integer: true }, inclusion: { in: 0..2 }
                     
  default_scope order: 'joiner_activities.position ASC'
end
