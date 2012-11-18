# == Schema Information
#
# Table name: currencies
#
#  id             :integer          not null, primary key
#  currency       :string(255)
#  code           :string(255)
#  created_by     :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  decimal_places :integer          default(2)
#

class Currency < ActiveRecord::Base
  attr_accessible :code, :currency, :decimal_places, :created_by
  
  has_many :countries
  
  validates :currency, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 3 },
  												uniqueness: { case_sensitive: false }
  validates :decimal_places, presence: true, numericality: { integer: true }
  												
  default_scope order: 'currencies.code ASC'
  
  def self_ref
    code
  end
  
  def currency_code
    "#{code} (#{currency})" 
  end
  
  def country_links
    self.countries.count
  end
  
  def linked?
    country_links > 0
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    Currency.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Currency.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
  def self.total_unlinked
    cnt = 0
    @currencies = self.all
    @currencies.each do |currency|
      unless currency.linked?
        cnt +=1
      end      
    end
    return cnt
  end
end
