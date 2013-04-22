# == Schema Information
#
# Table name: loan_cats
#
#  id                    :integer          not null, primary key
#  business_id           :integer
#  name                  :string(255)
#  qualifying_months     :integer          default(12)
#  max_repayment_months  :integer          default(12)
#  max_salary_multiplier :integer          default(12)
#  max_amount            :integer          default(1000)
#  apr                   :decimal(4, 2)    default(0.0)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class LoanCat < ActiveRecord::Base
  attr_accessible :apr, :created_by, :max_amount, :max_repayment_months, :max_salary_multiplier, :name, :qualifying_months, :updated_by
  belongs_to :business
  
  validates :business_id,						presence: true
  validates :name, 									presence: true, length: { maximum: 20 },
                     									uniqueness: { case_sensitive: false, scope: :business_id }
  validates :qualifying_months, 		presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_repayment_months, 	presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_salary_multiplier, presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000 }
  validates :max_amount, 						presence: true, numericality: { only_integer: true }, inclusion: { in: 0..1000000 }
  validates :apr, 									presence: true, numericality: true, inclusion: { in: 0..100 }
                     
  default_scope order: 'loan_cats.name ASC'
end
