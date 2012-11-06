# == Schema Information
#
# Table name: nationalities
#
#  id          :integer          not null, primary key
#  nationality :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Nationality < ActiveRecord::Base
  attr_accessible :nationality
  
  has_many :countries
  
  validates :nationality, presence: true, length: { maximum: 50 },
  												uniqueness: { case_sensitive: false }
  												
  default_scope order: 'nationalities.nationality ASC'
  
  def country_links
    self.countries.count
  end
  
  def linked?
    country_links > 0
  end
  
  def self.total_unlinked
    cnt = 0
    @nationalities = self.all
    @nationalities.each do |nationality|
      unless nationality.linked?
        cnt +=1
      end      
    end
    return cnt
  end
  
end
