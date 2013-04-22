# == Schema Information
#
# Table name: advance_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  name        :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe AdvanceCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @advance_type = FactoryGirl.create(:advance_type, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @advance_cat = @business.advance_cats.build(name: "Other")
  end
  
  subject { @advance_cat }

  it { should respond_to(:name) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        AdvanceCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @advance_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @advance_cat.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is nil" do
    before { @advance_cat.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @advance_cat.name = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate for the same business" do
    before do
      @duplicate = @advance_cat.dup
      @duplicate.name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @advance_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
end
