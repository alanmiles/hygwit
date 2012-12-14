# == Schema Information
#
# Table name: reserved_occupations
#
#  id           :integer          not null, primary key
#  country_id   :integer
#  jobfamily_id :integer
#  checked      :boolean          default(FALSE)
#  created_by   :integer          default(1)
#  updated_by   :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe ReservedOccupation do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Bahraini")
    @currency = FactoryGirl.create(:currency, currency: "Bahraini Dinars", code: "BHD")
    @country = Country.create(country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id)
    @jobfamily = Jobfamily.create(job_family: "Salesman")
    @occupation = @country.reserved_occupations.build(jobfamily_id: @jobfamily.id, checked: true, created_by: 999999)
  end
  
  subject { @occupation }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:jobfamily_id) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to country_id" do
      expect do
        GratuityFormula.new(country_id: @country.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when country_id is nil" do
    before { @occupation.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when jobfamily_id is nil" do
    before { @occupation.jobfamily_id = nil }
    it { should_not be_valid }
  end
  
  describe "when jobfamily_id and country_id are duplicates" do
    before { @country.reserved_occupations.create(jobfamily_id: @jobfamily.id) }
    it { should_not be_valid }
  end
  
  describe "when jobfamily_id is a duplicate but country_id is not" do
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "British")
      @currency_2 = FactoryGirl.create(:currency, currency: "Pound Sterling", code: "GBP")
      @country_2 = Country.create(country: "UK", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
      @occupation_2 = @country_2.reserved_occupations.create(jobfamily_id: @jobfamily.id)
    end
    it { should be_valid }
  end
  
  
end
