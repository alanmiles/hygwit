# == Schema Information
#
# Table name: pay_categories
#
#  id          :integer          not null, primary key
#  category    :string(255)
#  description :string(255)
#  on_payslip  :boolean          default(FALSE)
#  created_by  :integer          default(1)
#  checked     :boolean          default(FALSE)
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

class PayCategory < ActiveRecord::Base
  attr_accessible :category, :checked, :created_by, :description, :on_payslip, :updated_by, :position
  
  validates :category, 				presence: true, length: { maximum: 50 },
                     					uniqueness: { case_sensitive: false }
  validates :description,			length: { maximum: 254, allow_nil: true }
  validates :created_by, 			presence: true, numericality: { only_integer: true }
  
  default_scope order: 'pay_categories.position ASC'
  
  def self_ref
    category
  end
end
