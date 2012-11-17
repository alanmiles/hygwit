# == Schema Information
#
# Table name: leaving_reasons
#
#  id            :integer          not null, primary key
#  reason        :string(255)
#  full_benefits :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LeavingReason < ActiveRecord::Base
  attr_accessible :reason, :full_benefits
  
  validates :reason, presence: true, length: { maximum: 25 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'leaving_reasons.reason ASC'
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    LeavingReason.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    LeavingReason.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
