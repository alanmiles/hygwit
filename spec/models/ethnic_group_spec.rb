# == Schema Information
#
# Table name: ethnic_groups
#
#  id                :integer          not null, primary key
#  country_id        :integer
#  ethnic_group      :string(255)
#  checked           :boolean          default(FALSE)
#  created_by        :integer          default(1)
#  updated_by        :integer          default(1)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cancellation_date :date
#

require 'spec_helper'

describe EthnicGroup do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Indian")
    @currency = FactoryGirl.create(:currency, currency: "Rupee", code: "IRY")
    @country = Country.create(country: "India", nationality_id: @nationality.id, currency_id: @currency.id)
    @group = @country.ethnic_groups.build(ethnic_group: "White Caucasian")
  end
  
  subject { @group }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:ethnic_group) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should respond_to(:cancellation_date) }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to country_id" do
      expect do
        EthnicGroup.new(country_id: @country.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when country_id is nil" do
    before { @group.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when ethnic_group is empty" do
    before { @group.ethnic_group = " " }
    it { should_not be_valid }
  end
  
  describe "when ethnic_group is too long" do
    before { @group.ethnic_group = "a"*31 }
    it { should_not be_valid }
  end
  
  describe "when ethnic_group is a duplicate in the same country even if case is different" do
    before do
      @country.ethnic_groups.create(ethnic_group: "white caucasian")
    end
    it { should_not be_valid }
  end
  
  describe "when ethnic group is a duplicate but in a different country" do
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "British")
      @currency_2 = FactoryGirl.create(:currency, currency: "Pound Sterling", code: "GBP")
      @country_2 = Country.create(country: "United Kingdom", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
      @group_2 = @country_2.ethnic_groups.create(ethnic_group: "White Caucasian")
    end
    it { should be_valid }
  end
  
  describe "when created by is not a number" do 
    before { @group.created_by = "Alan" }
    it { should_not be_valid }
  end
  
  describe "when created_by is not an integer" do
    before { @group.created_by = 1.5 }
    it { should_not be_valid }
  end
  
  describe "when created_by is empty" do
    before { @group.created_by = nil }
    it { should_not be_valid }
  end
end
