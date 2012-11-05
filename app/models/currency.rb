# == Schema Information
#
# Table name: currencies
#
#  id             :integer          not null, primary key
#  currency       :string(255)
#  code           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  decimal_places :integer          default(2)
#

class Currency < ActiveRecord::Base
  attr_accessible :code, :currency, :decimal_places
  
  has_many :countries
  
  validates :currency, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 3 },
  												uniqueness: { case_sensitive: false }
  validates :decimal_places, presence: true, numericality: { integer: true }
  												
  default_scope order: 'currencies.code ASC'
  
  def currency_code
    "#{code} (#{currency})" 
  end
end