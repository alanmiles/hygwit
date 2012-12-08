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

  include UpdateCheck
  
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
  
  def recent?
    created_at >= 7.days.ago
  end
  
  def self.all_recent
    self.where("created_at >=?", 7.days.ago).count
  end
  
  def updated?
    updated_at >= 7.days.ago && created_at < 7.days.ago
  end
  
  def self.all_updated
    self.where("updated_at >=? and created_at <?", 7.days.ago, 7.days.ago).count
  end
  
  def add_check?
    checked == false && (created_at + 1.day >= updated_at)
  end
  
  def self.added_require_checks
    self.where("checked = ? AND (updated_at - created_at) < INTERVAL '1 day'", false).count
  end
  
  def update_check?
    checked == false && (created_at + 1.day < updated_at)
  end
  
  def self.updated_require_checks
    self.where("checked = ? AND (updated_at - created_at) >= INTERVAL '1 day'", false).count
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
