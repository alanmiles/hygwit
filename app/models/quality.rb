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
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

class Quality < ActiveRecord::Base
  
  attr_accessible :approved, :created_by, :quality, :checked, :updated_by
  
  after_create  :build_descriptors
  
  has_many :descriptors, dependent: :destroy
  
  validates :quality, presence: true, length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
  validates :created_by, presence: true
  
  default_scope order: 'qualities.quality ASC'
  
  def self_ref
    quality
  end
  
  private
  
    def build_descriptors
      @content = "Descriptor for "
      @grades = ["A", "B", "C", "D", "E"]
      @grades.each do |grade|
        self.descriptors.create(grade: grade, 
                   descriptor: "#{@content}" + grade.to_s,
                   updated_by: self.updated_by)  
      end
    end
end
