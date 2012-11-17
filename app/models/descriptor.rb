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
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.all_updated
    Descriptor.where("updated_at >=? and created_at <=?", 7.days.ago, 7.days.ago).count
  end
  
  def self.includes_updates?
    Descriptor.all_updated > 0
  end
  
  #def self.total_updated(quality)
  #  Descriptor.where("quality_id = ? and updated_at >=? and created_at <=?", quality.id, 7.days.ago, 7.days.ago).count
  #end
  
  def not_written?
    descriptor == "Descriptor for #{self.grade}"
  end
  
  def self.total_unwritten
    Descriptor.where("descriptor LIKE ?", "%Descriptor for%").count
  end
  
  def self.requires_edits?
    Descriptor.total_unwritten > 0
  end
 
end
