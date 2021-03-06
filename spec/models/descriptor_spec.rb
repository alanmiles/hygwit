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

require 'spec_helper'

describe Descriptor do
  
  before do
    @quality = Quality.create(quality: 'Punctuality', created_by: 1)
    @descriptor = Descriptor.find_by_quality_id_and_grade(@quality.id, "A")
    @descriptor_2 = Descriptor.find_by_quality_id_and_grade(@quality.id, "B")
  end
  
  subject { @descriptor }
  
  it { should respond_to(:grade) }
  it { should respond_to(:descriptor) }
  it { should respond_to(:reviewed) }
  it { should respond_to(:quality_id) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when 'quality_id' is missing" do
    before { @descriptor.quality_id = nil }
    it { should_not be_valid } 
  end
  
  describe "when 'updated_by' is missing" do
    before { @descriptor.updated_by = nil }
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
      @quality_3 = Quality.create(quality: 'Attendance', created_by: 1)
      @descriptor_3 = Descriptor.find_by_quality_id_and_grade(@quality_3.id, "A")
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
      @quality_3 = Quality.create(quality: 'Attendance', created_by: 1)
      @descriptor_3 = Descriptor.find_by_quality_id_and_descriptor(@quality_3.id, @descriptor.descriptor)
    end
    subject { @descriptor_3 }
    it { should be_valid }
  end
end
