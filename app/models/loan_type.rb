# == Schema Information
#
# Table name: loan_types
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  qualifying_months     :integer          default(12)
#  max_repayment_months  :integer          default(12)
#  max_salary_multiplier :integer          default(12)
#  max_amount            :integer          default(1000)
#  apr                   :decimal(4, 2)    default(0.0)
#  created_by            :integer          default(1)
#  checked               :boolean          default(FALSE)
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class LoanType < ActiveRecord::Base
  attr_accessible :checked, :created_by, :name, :updated_by, :qualifying_months, :max_repayment_months, :max_salary_multiplier,
  								:max_amount, :apr
  
  validates :name, presence: true, length: { maximum: 20 },
                     uniqueness: { case_sensitive: false }
  validates :qualifying_months, 	presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_repayment_months, 	presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_salary_multiplier, 	presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_amount, 	presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000000 }
  validates :apr, 	presence: true, numericality: true, inclusion: { in: 0..100 }
  validates :created_by, presence: true
  
  default_scope order: 'loan_types.name ASC'
  
  def self_ref
    name
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end
end
