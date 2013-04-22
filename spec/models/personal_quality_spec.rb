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

require 'spec_helper'

describe PersonalQuality do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @quality = FactoryGirl.create(:quality, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @personal_quality = @business.personal_qualities.build(quality: "Persistence")
  end
  
  subject { @personal_quality }

  it { should respond_to(:quality) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        PersonalQuality.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @personal_quality.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when quality is not present" do
    before { @personal_quality.quality = " " }
    it { should_not be_valid }
  end
  
  describe "when quality is nil" do
    before { @personal_quality.quality = nil }
    it { should_not be_valid }
  end
  
  describe "when quality is too long" do
    before { @personal_quality.quality = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when quality is a duplicate for the same business" do
    before do
      @duplicate = @personal_quality.dup
      @duplicate.quality.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when quality is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @personal_quality.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
