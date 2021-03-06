# == Schema Information
#
# Table name: insurance_codes
#
#  id             :integer          not null, primary key
#  country_id     :integer
#  insurance_code :string(255)
#  explanation    :string(255)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer          default(1)
#  cancelled      :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  created_by     :integer          default(1)
#

class InsuranceCode < ActiveRecord::Base
  
  attr_accessible :explanation, :checked, :insurance_code, :updated_by, :cancelled, :created_by
  
  belongs_to :country
  has_many :insurance_rates, dependent: :destroy
  
  before_save	:upcase_icode
  
  validates :country_id,								presence: true
  validates :insurance_code,            presence: true, length: { maximum: 5 }, uniqueness: { case_sensitive: false, scope: :country_id }
  validates :explanation,								presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: :country_id }
  validates :created_by,								presence: true, numericality: { integer: true }

  default_scope order: "insurance_codes.insurance_code"
  
  def self.on_current_list
    self.where("cancelled IS NULL or cancelled > ?", Date.today)  
  end
  
  def self.first_on_current_list
    self.on_current_list.first
  end
  
  def self.on_active_list(cancellation_date)
    self.where("cancelled IS NULL or cancelled > ?", cancellation_date)
  end
  
  def full_details
    @details = "#{insurance_code} - #{explanation}"
  end
  
  private
  
    def upcase_icode
      insurance_code.upcase!
    end
    
end
