# == Schema Information
#
# Table name: grievance_types
#
#  id         :integer          not null, primary key
#  grievance  :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class GrievanceType < ActiveRecord::Base
  
  attr_accessible :grievance, :created_by, :checked, :updated_by
  
  validates :grievance, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates	:created_by, 	presence: true
                     
  default_scope order: 'grievance_types.grievance ASC'
  
  def self_ref
    grievance
  end
  

end
