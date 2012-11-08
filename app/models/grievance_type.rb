# == Schema Information
#
# Table name: grievance_types
#
#  id         :integer          not null, primary key
#  grievance  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GrievanceType < ActiveRecord::Base
  attr_accessible :grievance
  
  validates :grievance, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'grievance_types.grievance ASC'
end
