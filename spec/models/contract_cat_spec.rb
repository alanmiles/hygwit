# == Schema Information
#
# Table name: contract_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  contract    :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe ContractCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @contract = FactoryGirl.create(:contract, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @contract_cat = @business.contract_cats.build(contract: "Part-time")
  end
  
  subject { @contract_cat }

  it { should respond_to(:contract) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        ContractCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @contract_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when contract is not present" do
    before { @contract_cat.contract = " " }
    it { should_not be_valid }
  end
  
  describe "when contract is nil" do
    before { @contract_cat.contract = nil }
    it { should_not be_valid }
  end
  
  describe "when contract is too long" do
    before { @contract_cat.contract = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when contract is a duplicate for the same business" do
    before do
      @duplicate = @contract_cat.dup
      @duplicate.contract.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when contract is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @contract_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
