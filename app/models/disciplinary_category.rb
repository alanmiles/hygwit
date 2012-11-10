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
end