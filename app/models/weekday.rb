# == Schema Information
#
# Table name: weekdays
#
#  id           :integer          not null, primary key
#  day          :string(255)
#  abbreviation :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Weekday < ActiveRecord::Base
  attr_accessible :day, :abbreviation
  
  #has_many :businesses
  
  validates :day, presence: true, length: { maximum: 10 },
                     uniqueness: { case_sensitive: false }
  validates :abbreviation, presence: true, length: { maximum: 3 },
                     uniqueness: { case_sensitive: false }
end
