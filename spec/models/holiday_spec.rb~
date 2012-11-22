# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Holiday do

  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Indian")
    @currency = FactoryGirl.create(:currency, currency: "Rupee", code: "IRY")
    @country = Country.create(country: "India", nationality_id: @nationality.id, currency_id: @currency.id)
    @holiday = @country.holidays.build(name: "Diwali", start_date: "2013-01-14", end_date: "2013-01-15")
  end
  
  subject { @holiday }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:name) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to country_id" do
      expect do
        Holiday.new(country_id: @country.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when country_id is nil" do
    before { @holiday.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name field is blank" do
    before { @holiday.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name field is nil" do
    before { @holiday.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name field is too long" do
    before { @holiday.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when start_date field is empty" do
    before { @holiday.start_date = nil }
    it { should_not be_valid }
  end
  
  describe "when end_date field is empty" do
    before { @holiday.end_date = nil }
    it { should_not be_valid }
  end
  
  describe "when holiday is too long" do
    before { @holiday.end_date = "2013-01-21" }
    it { should_not be_valid }
  end  
  
  describe "when start_date is a duplicate (for country)" do
    before do
      duplicate = @holiday.dup
      duplicate.end_date = "2013-01-20"
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate but dates are not" do
    before do
      same_name = @holiday.dup
      same_name.start_date = "2014-01-14" 
      same_name.end_date = "2014-01-15"
      same_name.save
    end
    it { should be_valid }  
  end
  
  describe "when end_date is a duplicate (for country)" do
    before do
      duplicate = @holiday.dup
      duplicate.start_date = "2013-01-13"
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when end_date is earlier than start date" do
    before { @holiday.end_date = "2013-01-13" }
    it { should_not be_valid }
  end
  
  describe "when holiday dates overlap" do
    before { @country.holidays.create(name: "National Day", start_date: "2013-01-12", end_date: "2013-01-14") }
    it { should_not be_valid }
  end
  
  describe "similar records but for different countries" do
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "British")
      @currency_2 = FactoryGirl.create(:currency, currency: "Pound Sterling", code: "GBP")
      @country_2 = Country.create(country: "UK", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
    end
    
    describe "duplicate dates" do
      before { @country_2.holidays.create(name: "Diwali", start_date: "2013-01-14", end_date: "2013-01-15") }
      it { should be_valid }
    end
    
    describe "overlapping dates" do
      before { @country_2.holidays.create(name: "National Day", start_date: "2013-01-12", end_date: "2013-01-14") }
      it { should be_valid }
    end
  end
   
end
