# == Schema Information
#
# Table name: ranks
#
#  id         :integer          not null, primary key
#  rank       :string(255)
#  position   :integer
#  created_by :integer          default(1)
#  checked    :boolean          default(FALSE)
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Rank < ActiveRecord::Base
  attr_accessible :checked, :created_by, :priority, :rank, :updated_by, :position
  acts_as_list
  
  validates :rank, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true, numericality: { only_integer: true }
  
  default_scope order: 'ranks.position ASC'
  
  def self_ref
    rank
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end 
end
