# == Schema Information
#
# Table name: gratuity_formulas
#
#  id                     :integer          not null, primary key
#  country_id             :integer
#  service_years_from     :integer
#  service_years_to       :integer
#  termination_percentage :decimal(5, 2)
#  resignation_percentage :decimal(5, 2)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  checked                :boolean          default(FALSE)
#  updated_by             :integer          default(1)
#  created_by             :integer          default(1)
#

require 'spec_helper'

describe GratuityFormula do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Bahraini")
    @currency = FactoryGirl.create(:currency, currency: "Bahraini Dinars", code: "BHD")
    @country = Country.create(country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id)
    @formula = @country.gratuity_formulas.build(service_years_from: 0, service_years_to: 3, termination_percentage: 50,
                                                resignation_percentage: 0)
  end
  
  subject { @formula }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:service_years_from) }
  it { should respond_to(:service_years_to) }
  it { should respond_to(:termination_percentage) }
  it { should respond_to(:resignation_percentage) }
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
    before { @formula.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when service_years_from is nil" do
    before { @formula.service_years_from = nil }
    it { should_not be_valid }
  end
  
  describe "when service_years_to is nil" do
    before { @formula.service_years_to = nil }
    it { should_not be_valid }
  end
  
  describe "when service_years_from is too large" do
    before { @formula.service_years_from = 101 }
    it { should_not be_valid }
  end
  
  describe "when service_years_to is too large" do
    before { @formula.service_years_to = 101 }
    it { should_not be_valid }
  end
  
  describe "when service_years_from is a negative" do
    before { @formula.service_years_from = -1 }
    it { should_not be_valid }
  end
  
  describe "when service_years_to is a negative" do
    before { @formula.service_years_to = -1 }
    it { should_not be_valid }
  end
  
  describe "when service_years_from is a fraction" do
    before { @formula.service_years_from = 75.3 }
    it { should_not be_valid }
  end
  
  describe "when service_years_to is a fraction" do
    before { @formula.service_years_to = 26.4 }
    it { should_not be_valid }
  end
  
  describe "when termination_percentage is nil" do
    before { @formula.termination_percentage = nil }
    it { should_not be_valid }
  end
  
  describe "when resignation_percentage is nil" do
    before { @formula.resignation_percentage = nil }
    it { should_not be_valid }
  end
  
  describe "when termination_percentage is too large" do
    before { @formula.termination_percentage = 101 }
    it { should_not be_valid }
  end
  
  describe "when resignation_percentage is too large" do
    before { @formula.resignation_percentage = 101 }
    it { should_not be_valid }
  end
  
  describe "when termination_percentage is a negative number" do
    before { @formula.termination_percentage = -1 }
    it { should_not be_valid }
  end
  
  describe "when resignation_percentage is a negative number" do
    before { @formula.resignation_percentage = -1 }
    it { should_not be_valid }
  end
  
  describe "when termination_percentage is a fraction" do
    before { @formula.termination_percentage = 26.85 }
    it { should be_valid }
  end
  
  describe "when resignation_percentage is a fraction" do
    before { @formula.resignation_percentage = 23.67 }
    it { should be_valid }
  end
  
  describe "when service_years_from is a duplicate" do
    before do
      duplicate = @formula.dup
      duplicate.service_years_to = 5
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when service_years_to is a duplicate" do
    before do
      duplicate = @formula.dup
      duplicate.service_years_from = 1
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when service_years_to is less than service_years_from" do
    before { @formula.service_years_from = 5 }
    it { should_not be_valid }
  end
  
  describe "when service_years_to the same as service_years_to" do
    before { @formula.service_years_from = 3 }
    it { should_not be_valid }
  end
  
  describe "when service periods overlap" do
    before { @country.gratuity_formulas.create(service_years_from: 1, service_years_to: 4,
    												termination_percentage: 75, resignation_percentage: 25) }
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @formula.created_by = nil }
    it { should_not be_valid }
  end
  
end
