# == Schema Information
#
# Table name: descriptors
#
#  id         :integer          not null, primary key
#  quality_id :integer
#  grade      :string(255)
#  descriptor :string(255)
#  reviewed   :boolean          default(FALSE)
#  updated_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Descriptor < ActiveRecord::Base
  attr_accessible :descriptor, :grade, :reviewed, :updated_by
  
  belongs_to :quality
  
  validates :quality_id, presence: true
  validates :grade,		presence: true, length: { maximum: 1 },
  										inclusion: { in: %w(A B C D E) }, uniqueness: { scope: :quality_id }
  validates :descriptor,  presence: true, length: { maximum: 250 }, uniqueness: { scope: :quality_id }
  validates :updated_by,	presence: true, numericality: { integer: true }
  
  default_scope order: 'descriptors.grade ASC'
end