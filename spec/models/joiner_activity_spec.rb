# == Schema Information
#
# Table name: joiner_activities
#
#  id             :integer          not null, primary key
#  business_id    :integer
#  action         :string(255)
#  contract       :integer          default(2)
#  residence      :integer          default(2)
#  nationality    :integer          default(2)
#  marital_status :integer          default(2)
#  position       :integer
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe JoinerActivity do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @action = FactoryGirl.create(:joiner_action, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @joiner_activity = @business.joiner_activities.build(action: "Induction")
  end
  
  subject { @joiner_activity }

  it { should respond_to(:action) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:position) }
  it { should respond_to(:contract) }
  it { should respond_to(:residence) }
  it { should respond_to(:nationality) }
  it { should respond_to(:marital_status) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        JoinerActivity.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @joiner_activity.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when action is not present" do
    before { @joiner_activity.action = " " }
    it { should_not be_valid }
  end
  
  describe "when action is nil" do
    before { @joiner_activity.action = nil }
    it { should_not be_valid }
  end
  
  describe "when action is too long" do
    before { @joiner_activity.action = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when action is a duplicate for the same business" do
    before do
      @duplicate = @joiner_activity.dup
      @duplicate.action.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when action is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @joiner_activity.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
  
  describe "when contract is empty" do
    before { @joiner_activity.contract = nil }
    it { should_not be_valid } 
  end  
  
  describe "when contract is not within permitted range 0-2" do
    before { @joiner_activity.contract = 3 }
    it { should_not be_valid } 
  end
  
  describe "when contract is not an integer" do
    before { @joiner_activity.contract = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when nationality is empty" do
    before { @joiner_activity.nationality = nil }
    it { should_not be_valid } 
  end  
  
  describe "when nationality is not within permitted range 0-2" do
    before { @joiner_activity.nationality = 3 }
    it { should_not be_valid } 
  end
  
  describe "when nationality is not an integer" do
    before { @joiner_activity.nationality = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when residence is empty" do
    before { @joiner_activity.residence = nil }
    it { should_not be_valid } 
  end  
  
  describe "when residence is not within permitted range 0-2" do
    before { @joiner_activity.residence = 3 }
    it { should_not be_valid } 
  end
  
  describe "when residence is not an integer" do
    before { @joiner_activity.residence = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when marital_status is empty" do
    before { @joiner_activity.marital_status = nil }
    it { should_not be_valid } 
  end  
  
  describe "when marital_status is not within permitted range 0-2" do
    before { @joiner_activity.marital_status = 3 }
    it { should_not be_valid } 
  end
  
  describe "when marital_status is not an integer" do
    before { @joiner_activity.marital_status = "Yes" }
    it { should_not be_valid } 
  end
end
