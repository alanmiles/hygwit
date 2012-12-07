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

  include UpdateCheck
  
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
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.all_updated
    Nationality.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
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
  
  def self.all_recent
    Nationality.where("created_at >=?", 7.days.ago).count
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def self.added_require_checks
    self.where("checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", false).count
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def self.updated_require_checks
    self.where("checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", false).count
  end 
  
end
