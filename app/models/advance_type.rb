# == Schema Information
#
# Table name: advance_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_by :integer          default(1)
#  checked    :boolean          default(FALSE)
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdvanceType < ActiveRecord::Base
  attr_accessible :checked, :created_by, :name, :updated_by
  
  validates :name, presence: true, length: { maximum: 20 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'advance_types.name ASC'
  
  def self_ref
    name
  end
  
  def self.all_checked
    self.where("checked =?", true)
  end
end
