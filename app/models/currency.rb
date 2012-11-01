# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  currency   :string(255)
#  code       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Currency < ActiveRecord::Base
  attr_accessible :code, :currency
  
  validates :currency, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 3 },
  												uniqueness: { case_sensitive: false }
  												
  default_scope order: 'currencies.code ASC'
end
