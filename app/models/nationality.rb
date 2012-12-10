# == Schema Information
#
# Table name: nationalities
#
#  id          :integer          not null, primary key
#  nationality :string(255)
#  created_by  :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  checked     :boolean          default(FALSE)
#  updated_by  :integer          default(1)
#

class Nationality < ActiveRecord::Base

  attr_accessible :nationality, :created_by, :updated_by, :checked
  
  has_many :countries
 
  validates :nationality, presence: true, length: { maximum: 50 },
  												uniqueness: { case_sensitive: false }
  												
  default_scope order: 'nationalities.nationality ASC'
  
  def self_ref
    nationality
  end
  
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
