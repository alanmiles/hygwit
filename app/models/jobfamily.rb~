# == Schema Information
#
# Table name: jobfamilies
#
#  id         :integer          not null, primary key
#  job_family :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Jobfamily < ActiveRecord::Base
  attr_accessible :approved, :created_by, :job_family
  
  validates :job_family, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
end
