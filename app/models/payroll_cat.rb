# == Schema Information
#
# Table name: payroll_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  category    :string(255)
#  description :string(255)
#  on_payslip  :boolean          default(FALSE)
#  position    :integer
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PayrollCat < ActiveRecord::Base
  attr_accessible :category, :created_by, :description, :on_payslip, :position, :updated_by
  acts_as_list
  
  belongs_to :business
  has_many :payroll_items
  
  validates :business_id,		presence: true
  validates :category, 			presence: true, length: { maximum: 50 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
  validates :description,		length: { maximum: 254, allow_blank: true }
                     
  default_scope order: 'payroll_cats.position ASC'
end
