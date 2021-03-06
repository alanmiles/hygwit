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

require 'spec_helper'

describe QualityDescriptor do

  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @quality = @business.personal_qualities.create(quality: "Attendance")
    @descriptor = QualityDescriptor.find_by_personal_quality_id_and_grade(@quality.id, "A")
    @descriptor_2 = QualityDescriptor.find_by_personal_quality_id_and_grade(@quality.id, "B")
  end
  
  subject { @descriptor }
  
  it { should respond_to(:grade) }
  it { should respond_to(:descriptor) }
  it { should respond_to(:personal_quality_id) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to personal_quality_id" do
      expect do
        QualityDescriptor.new(personal_quality_id: @quality.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when 'personal_quality_id' is missing" do
    before { @descriptor.personal_quality_id = nil }
    it { should_not be_valid } 
  end
  
  describe "when grade is not present" do
    before { @descriptor.grade = " " }
    it { should_not be_valid }
  end
  
  describe "when grade is nil" do
    before { @descriptor.grade = nil }
    it { should_not be_valid }
  end
  
  describe "when grade is too long" do
    before { @descriptor.grade = "a" * 2 }
    it { should_not be_valid }
  end
  
  describe "when grade is a duplicate (for same Quality)" do
    before { @descriptor.grade = 'b' }
    it { should_not be_valid }
  end
  
  describe "when grade is a duplicate (for a different Quality)" do
    before do
      @quality_3 = @business.personal_qualities.create(quality: 'Empathy')
      @descriptor_3 = QualityDescriptor.find_by_personal_quality_id_and_grade(@quality_3.id, "A")
    end
    subject { @descriptor_3 }
    it { should be_valid }
  end
  
  describe "when descriptor is not present" do
    before { @descriptor.descriptor = " " }
    it { should_not be_valid }
  end
  
  describe "when descriptor is nil" do
    before { @descriptor.descriptor = nil }
    it { should_not be_valid }
  end
  
  describe "when descriptor is too long" do
    before { @descriptor.descriptor = "a" * 251 }
    it { should_not be_valid }
  end
  
  describe "when descriptor is a duplicate (for same Quality)" do
    before { @descriptor.descriptor = @descriptor_2.descriptor }
    it { should_not be_valid }
  end
  
  describe "when descriptor is a duplicate (for a different Quality)" do
    before do
      @quality_3 = @business.personal_qualities.create(quality: 'Persuasiveness')
      @descriptor_3 = QualityDescriptor.find_by_personal_quality_id_and_descriptor(@quality_3.id, @descriptor.descriptor)
    end
    subject { @descriptor_3 }
    it { should be_valid }
  end
end
