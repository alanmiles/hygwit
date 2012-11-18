# == Schema Information
#
# Table name: grievance_types
#
#  id         :integer          not null, primary key
#  grievance  :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GrievanceType < ActiveRecord::Base
  attr_accessible :grievance, :created_by
  
  validates :grievance, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
                     
  default_scope order: 'grievance_types.grievance ASC'
  
  def self_ref
    grievance
  end
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.total_recent
    GrievanceType.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    GrievanceType.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
end
