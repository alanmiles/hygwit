# == Schema Information
#
# Table name: divisions
#
#  id          :integer          not null, primary key
#  business_id :integer
#  division    :string(255)
#  current     :boolean          default(TRUE)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Division do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @division = @business.divisions.build(division: "Central")
  end
  
  
  subject { @division }
  
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:division) }
  it { should respond_to(:current) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        Division.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @division.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when division field is blank" do
    before { @division.division = " " }
    it { should_not be_valid }
  end
  
  describe "when division field is nil" do
    before { @division.division = nil }
    it { should_not be_valid }
  end
  
  describe "when division field is too long" do
    before { @division.division = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when division is a duplicate (for business)" do
    before do
      duplicate = @division.dup
      duplicate.division = duplicate.division.upcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when division is a duplicate but for another business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save      
      non_dup = @business_2.divisions.create(division: "Central")
    end
    it { should be_valid }  
  end
end 
