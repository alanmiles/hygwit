# == Schema Information
#
# Table name: grievance_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  grievance   :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe GrievanceCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @grievance_type = FactoryGirl.create(:grievance_type, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @grievance_cat = @business.grievance_cats.build(grievance: "Aggression")
  end
  
  subject { @grievance_cat }

  it { should respond_to(:grievance) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        GrievanceCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @grievance_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when grievance is not present" do
    before { @grievance_cat.grievance = " " }
    it { should_not be_valid }
  end
  
  describe "when grievance is nil" do
    before { @grievance_cat.grievance = nil }
    it { should_not be_valid }
  end
  
  describe "when grievance is too long" do
    before { @grievance_cat.grievance = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when grievance is a duplicate for the same business" do
    before do
      @duplicate = @grievance_cat.dup
      @duplicate.grievance.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when grievance is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @grievance_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
