# == Schema Information
#
# Table name: disciplinary_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  category    :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DisciplinaryCat < ActiveRecord::Base
  attr_accessible :category, :created_by, :updated_by
  
  belongs_to :business
  
  validates :business_id,		presence: true
  validates :category, 			presence: true, length: { maximum: 50 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'disciplinary_cats.category ASC'
end
