# == Schema Information
#
# Table name: leaving_reasons
#
#  id            :integer          not null, primary key
#  reason        :string(255)
#  full_benefits :boolean          default(FALSE)
#  created_by    :integer          default(1)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  checked       :boolean          default(FALSE)
#  updated_by    :integer          default(1)
#

class LeavingReason < ActiveRecord::Base
  
  attr_accessible :reason, :full_benefits, :created_by, :updated_by, :checked
  
  validates :reason, presence: true, length: { maximum: 25 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'leaving_reasons.reason ASC'
  
  def self_ref
    reason
  end
  

end
