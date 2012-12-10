# == Schema Information
#
# Table name: disciplinary_categories
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class DisciplinaryCategory < ActiveRecord::Base

  attr_accessible :category, :created_by, :updated_by, :checked
  
  validates :category, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
                                         
  default_scope order: 'disciplinary_categories.category ASC'
  
  def self_ref
    category
  end
  
end
