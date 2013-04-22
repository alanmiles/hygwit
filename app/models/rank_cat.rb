# == Schema Information
#
# Table name: rank_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  rank        :string(255)
#  position    :integer
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RankCat < ActiveRecord::Base
  attr_accessible :created_by, :position, :rank, :updated_by
  acts_as_list
  
  belongs_to :business
  
  validates :business_id,		presence: true
  validates :rank, 		presence: true, length: { maximum: 25 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'rank_cats.position ASC'
end
