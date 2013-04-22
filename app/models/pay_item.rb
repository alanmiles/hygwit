# == Schema Information
#
# Table name: pay_items
#
#  id              :integer          not null, primary key
#  item            :string(255)
#  pay_category_id :integer
#  short_name      :string(255)
#  deduction       :boolean          default(FALSE)
#  taxable         :boolean          default(FALSE)
#  fixed           :boolean          default(FALSE)
#  position        :integer
#  created_by      :integer          default(1)
#  checked         :boolean          default(FALSE)
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PayItem < ActiveRecord::Base
  attr_accessible :short_name, :deduction, :fixed, :item, :pay_category_id, :position, :taxable, :created_by, :checked, :updated_by
  acts_as_list
  
  belongs_to :pay_category
  
  validates :item, 		 				presence: true, length: { maximum: 35 },
                     					uniqueness: { case_sensitive: false }
  validates :short_name, 		 	presence: true, length: { maximum: 10 },
                     					uniqueness: { case_sensitive: false }
  validates :pay_category_id, presence: true
  validates :created_by, 			presence: true, numericality: { only_integer: true }
  
  default_scope order: 'pay_items.position ASC'
 
  def self_ref
    item
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end
end
