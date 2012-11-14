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
end
