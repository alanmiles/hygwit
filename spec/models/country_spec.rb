# == Schema Information
#
# Table name: countries
#
#  id                       :integer          not null, primary key
#  country                  :string(255)
#  nationality_id           :integer
#  currency_id              :integer
#  taxation                 :boolean          default(FALSE)
#  insurance                :boolean          default(TRUE)
#  probation_days           :integer          default(90)
#  max_hours_day            :decimal(, )      default(9.0)
#  max_hours_week           :decimal(, )      default(45.0)
#  max_hours_day_ramadan    :decimal(, )
#  max_hours_week_ramadan   :decimal(, )
#  sickness_accruals        :boolean          default(FALSE)
#  retirement_age_m         :integer          default(60)
#  retirement_age_f         :integer          default(55)
#  OT_rate_standard         :decimal(3, 2)
#  OT_rate_special          :decimal(3, 2)
#  nightwork_start          :time
#  nightwork_end            :time
#  max_loan_ded_salary      :integer          default(15)
#  notes                    :text
#  complete                 :boolean          default(FALSE)
#  created_by               :integer          default(1)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rules                    :string(255)
#  gratuity_applies         :boolean          default(FALSE)
#  minimum_vacation_days    :integer          default(21)
#  vacation_by_working_days :boolean          default(FALSE)
#  gratuity_ceiling_months  :integer
#  gratuity_ceiling_value   :integer
#  checked                  :boolean          default(FALSE)
#  updated_by               :integer          default(1)
#  ethnicity_reports        :boolean          default(FALSE)
#  ethnicity_details        :text
#  reserved_jobs            :boolean          default(FALSE)
#  disability_rules         :boolean          default(FALSE)
#  disability_details       :text
#

require 'spec_helper'

describe Country do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Canadian")
    @currency = FactoryGirl.create(:currency, currency: "Canadian Dollars", code: "CAD")
    @country = Country.new(country: "Canada", nationality_id: @nationality.id, currency_id: @currency.id)
  end
  
  subject { @country }
  
  it { should respond_to(:country) }
  it { should respond_to(:nationality_id) }
  it { should respond_to(:currency_id) }
  it { should respond_to(:taxation) }
  it { should respond_to(:complete) }
  it { should respond_to(:rules) }
  it { should respond_to(:minimum_vacation_days) }
  it { should respond_to(:country_absences) }
  it { should respond_to(:holidays) }
  it { should respond_to(:gratuity_ceiling_months) }
  it { should respond_to(:gratuity_ceiling_value) }
  it { should respond_to(:gratuity_formulas) }
  it { should respond_to(:insurance_settings) }
  it { should respond_to(:insurance_codes) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should respond_to(:ethnicity_reports) }
  it { should respond_to(:ethnicity_details) }
  it { should respond_to(:reserved_jobs) }
  it { should respond_to(:disability_rules) }
  it { should respond_to(:disability_details) }
  it { should respond_to(:ethnic_groups) }
  it { should respond_to(:reserved_occupations) }
  
  it { should be_valid }
  
  describe "when country is blank" do
    before { @country.country = " " }
    it { should_not be_valid }
  end
  
  describe "when nationality_id is empty" do
    before { @country.nationality_id = nil }
    it { should_not be_valid }
  end
  
  describe "when currency_id is empty" do
    before { @country.currency_id = nil }
    it { should_not be_valid }
  end
  
  describe "when max_hours_day is a decimal" do
    before { @country.max_hours_day = 8.5 }
    it { should be_valid }
  end
  
  describe "when max_hours_day is not a number" do
    before { @country.max_hours_day = "8 hrs" }
    it { should_not be_valid }
  end
  
  describe "when max_hours_week is a decimal" do
    before { @country.max_hours_week = 37.5 }
    it { should be_valid }
  end
  
  describe "when max_hours_week is not a number" do
    before { @country.max_hours_week = "37.5 hrs" }
    it { should_not be_valid }
  end
  
  describe "when max_hours_day_ramadan is a decimal" do
    before { @country.max_hours_day_ramadan = 8.5 }
    it { should be_valid }
  end
  
  describe "when max_hours_day_ramadan is not a number" do
    before { @country.max_hours_day_ramadan = "8 hrs" }
    it { should_not be_valid }
  end
  
  describe "when max_hours_day_ramadan is nil" do
    before { @country.max_hours_day_ramadan = nil }
    it { should be_valid }
  end
  
  describe "when max_hours_week_ramadan is a decimal" do
    before { @country.max_hours_week_ramadan = 37.5 }
    it { should be_valid }
  end
  
  describe "when max_hours_week_ramadan is not a number" do
    before { @country.max_hours_week_ramadan = "37.5 hrs" }
    it { should_not be_valid }
  end
  
  describe "when max_hours_week_ramadan is nil" do
    before { @country.max_hours_week_ramadan = nil }
    it { should be_valid }
  end
  
  describe "when gratuity_ceiling_months is a decimal" do
    before { @country.gratuity_ceiling_months = 37.5 }
    it { should_not be_valid }
  end
  
  describe "when gratuity_ceiling_months is not a number" do
    before { @country.gratuity_ceiling_months = "37 months" }
    it { should_not be_valid }
  end
  
  describe "when gratuity_ceiling_months is nil" do
    before { @country.gratuity_ceiling_months = nil }
    it { should be_valid }
  end
  
  
  describe "when gratuity_ceiling_value is a decimal" do
    before { @country.gratuity_ceiling_value = 40000.5 }
    it { should_not be_valid }
  end
  
  describe "when gratuity_ceiling_value is not a number" do
    before { @country.gratuity_ceiling_value = "40000 months" }
    it { should_not be_valid }
  end
  
  describe "when gratuity_ceiling_value is nil" do
    before { @country.gratuity_ceiling_value = nil }
    it { should be_valid }
  end
  
  describe "when gratuity_applies is off" do
    before do
      @country.gratuity_applies = false
      @country.gratuity_ceiling_months = 24
      @country.gratuity_ceiling_value = 40000
    end
  
    it { should_not be_valid }
  end
  
  #describe "when a comma is added in entry of gratuity_ceiling_value" do
  #  before { @country.gratuity_ceiling_value = 40,000 }
  #  it { should_not be_valid }
  #end
  
  describe "when country is too long" do
    before { @country.country = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when country is a duplicate" do
    before do
      duplicate_country = @country.dup
      duplicate_country.country.downcase
      duplicate_country.save
    end
    it { should_not be_valid }
  end
  
  describe "when a comma is entered instead of a decimal point in a numeric field" do
    it "should convert automatically to a decimal point"
  end
  
  describe "when rules is too long" do
    before { @country.rules = "a" * 21 }
    it { should_not be_valid }
  end  
  
  describe "when rules is blank" do
    before { @country.rules = " " }
    it { should be_valid }
  end
  
  describe "automatic creation of country absence codes with new country" do
    before do
      5.times { FactoryGirl.create(:absence_type) }
      @country.country = "UAE"
      @country.save
      @absences = @country.country_absences
      @count = @absences.count
    end   
    subject { @count } 
    it { should == 5 }

    describe "no further absence code creation with country update" do
      before do
        @nationality_2 = FactoryGirl.create(:nationality, nationality: 'Emirati')
        @country.nationality_id = @nationality_2.id
        @country.save
        @absences = @country.country_absences
        @count = @absences.count
      end   
      it { should == 5 }
    end
    
    describe "and also adds country absence codes for a second country" do
      before do
        @nationality_3 = FactoryGirl.create(:nationality, nationality: 'British')
        @currency_3 = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
        @country_3 = FactoryGirl.create(:country, country: "UK", nationality_id: @nationality_3.id,
        																currency_id: @currency_3.id)
        @absences = CountryAbsence.all
        @count = @absences.count
        
        
      end
      it { should == 10 }
    end
  end
  
end
  
