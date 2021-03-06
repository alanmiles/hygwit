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
#  checked    :boolean          default(FALSE)
#

class Descriptor < ActiveRecord::Base

  
  attr_accessible :descriptor, :grade, :reviewed, :updated_by, :checked
  
  belongs_to :quality
  
  validates :quality_id, presence: true
  validates :grade,		presence: true, length: { maximum: 1 },
  										inclusion: { in: %w(A B C D E) }, uniqueness: { scope: :quality_id }
  validates :descriptor,  presence: true, length: { maximum: 250 }, uniqueness: { scope: :quality_id }
  validates :updated_by,	presence: true, numericality: { integer: true }
  
  default_scope order: 'descriptors.grade ASC'
  
  def recent_update?
    unless not_written?
      updated_at >= 7.days.ago
    end
  end
  
  def self.count_updates
    Descriptor.where("updated_at >=? and descriptor NOT LIKE ?", 7.days.ago, "%Descriptor for%").count
  end
  
  def self.includes_updates?
    Descriptor.count_updates > 0
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
  
  def self.requires_writing?
    Descriptor.total_unwritten > 0
  end
  
  def still_unchecked?
    unless not_written?
      checked == false
    end
  end
  
  def self.total_unchecked
    Descriptor.where("checked = ? and descriptor NOT LIKE ?", false, "%Descriptor for%").count
  end
  
  def self.requires_checking?
    Descriptor.total_unchecked > 0  
  end
 
end
