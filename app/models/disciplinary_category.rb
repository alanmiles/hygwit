# == Schema Information
#
# Table name: disciplinary_categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DisciplinaryCategory < ActiveRecord::Base
  attr_accessible :category
  
  validates :category, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
                                         
  default_scope order: 'disciplinary_categories.category ASC'
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    DisciplinaryCategory.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    DisciplinaryCategory.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
end
