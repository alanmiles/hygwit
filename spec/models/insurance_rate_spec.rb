# == Schema Information
#
# Table name: insurance_rates
#
#  id                :integer          not null, primary key
#  country_id        :integer
#  insurance_code_id :integer
#  source_employee   :boolean          default(TRUE)
#  threshold_id      :integer
#  ceiling_id        :integer
#  contribution      :decimal(, )
#  percent           :boolean          default(TRUE)
#  rebate            :boolean          default(FALSE)
#  created_by        :integer          default(1)
#  updated_by        :integer          default(1)
#  checked           :boolean          default(FALSE)
#  effective         :date
#  cancellation      :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe InsuranceRate do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Bahraini")
    @currency = FactoryGirl.create(:currency, currency: "Bahraini Dinars", code: "BHD")
    @country = Country.create(country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id)
    @code_1 = @country.insurance_codes.create(insurance_code: "A", explanation: "Default employee")
    @code_2 = @country.insurance_codes.create(insurance_code: "B", explanation: "Pension age")
    @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
    @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
    @setting_3 = @country.insurance_settings.create(shortcode: "ST", name: "Secondary Threshold", weekly_milestone: 500, 
    										monthly_milestone: 2000, annual_milestone: 24000, effective_date: Date.today - 60.days)										
    @rate = @country.insurance_rates.build(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10.5, created_by: 999999, updated_by: 999999,
    										checked: true, effective: Date.today - 60.days)
  end
  
  subject { @rate }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:insurance_code_id) }
  it { should respond_to(:source_employee) }
  it { should respond_to(:threshold_id) }
  it { should respond_to(:ceiling_id) }
  it { should respond_to(:contribution) }
  it { should respond_to(:percent) }
  it { should respond_to(:rebate) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should respond_to(:effective) }
  it { should respond_to(:cancellation) }  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to country_id" do
      expect do
        GratuityFormula.new(country_id: @country.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when country_id is nil" do
    before { @rate.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when insurance_code_id is nil" do
    before { @rate.insurance_code_id = nil }
    it { should_not be_valid }
  end
  
  describe "when insurance_code_id and country_id, source_employee, rebate, threshold_id and effective are duplicates" do
    before { @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 20, effective: Date.today - 60) }
    it { should_not be_valid }
  end
  
  describe "when insurance_code_id, country_id, source_employee, threshold_id, effective are duplicates but not rebate" do
    before { @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 20, rebate: true, effective: Date.today - 60) }
    it { should be_valid }
  end
  
  describe "when insurance_code_id, country_id, rebate, threshold_id, effective are duplicates but not source_employee" do
    before { @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 20, source_employee: false, effective: Date.today - 60) }
    it { should be_valid }
  end
  
  describe "when insurance_code_id, country_id, rebate, source_employee, threshold_id are duplicates but not effective" do
    before { @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 20, effective: Date.today - 420.days) }
    it { should be_valid }
  end
  
  describe "when insurance_code_id, country_id, rebate, source_employee, effective are duplicates but not threshold_id" do
    before { @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										ceiling_id: @setting_3.id, contribution: 20, effective: Date.today - 60.days) }
    it { should be_valid }
  end
  
  describe "when threshold_id is nil" do
    before { @rate.threshold_id = nil }
    it { should_not be_valid }
  end
  
  describe "when ceiling_id is nil" do
    before { @rate.ceiling_id = nil }
    it { should be_valid }
  end
  
  describe "when contribution is nil" do
    before { @rate.contribution = nil }
    it { should_not be_valid }
  end
  
  describe "when contribution is not a number" do
    before { @rate.contribution = "One" }
    it { should_not be_valid }
  end
  
  describe "when created_by is nil" do
    before { @rate.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when effective is nil" do
    before { @rate.effective = nil }
    it { should_not be_valid }
  end
  
  describe "when the value of ceiling is less than the value of threshold" do
    before do
      @rate.threshold_id = @setting_2.id
      @rate.ceiling_id = @setting_1.id
    end
    it { should_not be_valid }
  end
  
  describe "when the value of ceiling is the same as the value of threshold" do
    before { @rate.ceiling_id = @setting_1.id }
    it { should_not be_valid }
  end
  
  describe "when the setting code is the same for both threshold and ceiling" do
    before do
      @setting_1_old = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 90, 
    										monthly_milestone: 360, annual_milestone: 4320, effective_date: Date.today - 420.days)
      @rate.threshold_id = @setting_1_old.id
      @rate.ceiling_id = @setting_1.id
    end
    it { should_not be_valid }
  end
  
  describe "when it's a different country" do
    
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "British")
      @currency_2 = FactoryGirl.create(:currency, currency: "Pound Sterling", code: "GBP")
      @country_2 = Country.create(country: "UK", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
    end
    
    describe "when the insurance_code_id is a duplicate" do
      before { @country_2.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										ceiling_id: @setting_3.id, contribution: 20, effective: Date.today - 60.days) }
    	it { should be_valid }
    
    end
  end
  
  describe "rate should be auto-deleted when the threshold_id is deleted in insurance_settings" do  
    
    before do
      @id = @setting_1.id
      @setting_1.destroy
    end
    @records = InsuranceRate.where("threshold_id =?", @id).count
    @records.should == 0
  end
  
  describe "rate should be auto-deleted when the ceiling_id is deleted in insurance_settings" do  
    
    before do
      @id = @setting_2.id
      @setting_2.destroy
    end 
    @records = InsuranceRate.where("ceiling_id =?", @id).count
    @records.should == 0
  end
end
