# == Schema Information
#
# Table name: leaving_cats
#
#  id            :integer          not null, primary key
#  business_id   :integer
#  reason        :string(255)
#  full_benefits :boolean          default(FALSE)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe LeavingCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @leaving_reason = FactoryGirl.create(:leaving_reason, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @leaving_cat = @business.leaving_cats.build(reason: "Terminated", created_by: 1)
  end
  
  subject { @leaving_cat }

  it { should respond_to(:reason) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:full_benefits) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        LeavingCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @leaving_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when reason is not present" do
    before { @leaving_cat.reason = " " }
    it { should_not be_valid }
  end
  
  describe "when reason is nil" do
    before { @leaving_cat.reason = nil }
    it { should_not be_valid }
  end
  
  describe "when reason is too long" do
    before { @leaving_cat.reason = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when reason is a duplicate for the same business" do
    before do
      @duplicate = @leaving_cat.dup
      @duplicate.reason.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when reason is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @leaving_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
