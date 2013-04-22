# == Schema Information
#
# Table name: quality_descriptors
#
#  id                  :integer          not null, primary key
#  personal_quality_id :integer
#  grade               :string(255)
#  descriptor          :string(255)
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class QualityDescriptor < ActiveRecord::Base
  attr_accessible :created_by, :descriptor, :grade, :updated_by
  belongs_to :personal_quality
  
  validates :personal_quality_id,		presence: true
  validates :grade,									presence: true, length: { maximum: 1 },
  																		inclusion: { in: %w(A B C D E) }, uniqueness: { scope: :personal_quality_id }
  validates :descriptor,  					presence: true, length: { maximum: 250 }, uniqueness: { scope: :personal_quality_id }
  
  default_scope order: 'quality_descriptors.grade ASC'
end
