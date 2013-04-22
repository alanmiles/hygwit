# == Schema Information
#
# Table name: personal_qualities
#
#  id          :integer          not null, primary key
#  business_id :integer
#  quality     :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PersonalQuality < ActiveRecord::Base
  attr_accessible :created_by, :quality, :updated_by
  belongs_to :business
  has_many :quality_descriptors, dependent: :destroy
  
  after_create  :build_q_descriptors
  
  validates :business_id,		presence: true
  validates :quality, 		  presence: true, length: { maximum: 50 },
                     				uniqueness: { case_sensitive: false, scope: :business_id }
                     
  default_scope order: 'personal_qualities.quality ASC'
  
  private
  
    def build_q_descriptors
      @content = "Descriptor for "
      @grades = ["A", "B", "C", "D", "E"]
      @grades.each do |grade|
        self.quality_descriptors.create(grade: grade, 
                   descriptor: "#{@content}" + grade.to_s)  
      end
    end
end
