# == Schema Information
#
# Table name: qualities
#
#  id         :integer          not null, primary key
#  quality    :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quality < ActiveRecord::Base
  
  attr_accessible :approved, :created_by, :quality
  
  after_create  :build_descriptors
  
  has_many :descriptors, dependent: :destroy
  
  validates :quality, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'qualities.quality ASC'
  
  def self_ref
    quality
  end
  
  def recent?
    approved == false
  end
  
  def self.total_recent
    Quality.where("approved =?", false).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.total_updated
    Quality.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
  private
  
    def build_descriptors
      @content = "Descriptor for "
      @grades = ["A", "B", "C", "D", "E"]
      @grades.each do |grade|
        self.descriptors.create(grade: grade, 
                   descriptor: "#{@content}" + grade.to_s)  
      end
    end
end
