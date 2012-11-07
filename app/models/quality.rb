# == Schema Information
#
# Table name: qualities
#
#  id         :integer          not null, primary key
#  quality    :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quality < ActiveRecord::Base
  attr_accessible :approved, :created_by, :quality
  
  validates :quality, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'qualities.quality ASC'
end
