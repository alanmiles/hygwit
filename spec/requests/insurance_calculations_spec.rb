#deals with InsuranceRates

require 'spec_helper'

describe "InsuranceCalculations" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "British")
    @currency = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
    @country = FactoryGirl.create(:country, country: "United Kingdom", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, insurance: true)
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
    										checked: true)						    																				
  end
  
  describe "when not logged in" do
  
  end
  
  describe "when logged in as non-admin" do
  
  end
  
  describe "when logged in as admin" do
  
    describe "but not a country admin" do
    
    
    end
    
    describe "and as a country admin" do
    
    end
  end
  
  describe "when logged in as superuser" do
  
  
  end
end
