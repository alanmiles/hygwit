# == Schema Information
#
# Table name: businesses
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  country_id            :integer
#  address_1             :string(255)
#  address_2             :string(255)
#  city                  :string(255)
#  sector_id             :integer
#  created_by            :integer
#  updated_by            :integer
#  registration_number   :string(255)
#  bank                  :string(255)      default("(Name of your payroll bank)")
#  bank_branch           :string(255)      default("(Branch identifier)")
#  iban                  :string(255)      default("(Business iban code)")
#  calendar_days         :boolean          default(TRUE)
#  hours_per_day         :decimal(4, 2)    default(8.0)
#  hours_per_month       :decimal(5, 2)    default(160.0)
#  weekend_day_1         :integer          default(6)
#  weekend_day_2         :integer          default(7)
#  standard_ot_rate      :decimal(3, 2)    default(1.25)
#  supplementary_ot_rate :decimal(3, 2)    default(1.5)
#  double_ot_rate        :decimal(3, 2)    default(2.0)
#  standard_start_time   :string(255)      default("08:00")
#  autocalc_benefits     :boolean          default(FALSE)
#  pension_scheme        :boolean          default(FALSE)
#  bonus_provision       :boolean          default(FALSE)
#  close_date            :integer          default(15)
#  last_payroll_date     :date
#  home_airport          :string(255)
#  review_interval       :integer          default(6)
#  setup_complete        :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Business do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Saudi")
    @currency = FactoryGirl.create(:currency, currency: "Saudi Riyals", code: "SAR")
    @country = FactoryGirl.create(:country, country: "Saudi Arabia", nationality_id: @nationality.id, currency_id: @currency.id)
    @country_2 = FactoryGirl.create(:country, country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id)
    @sector = FactoryGirl.create(:sector)
    @sector_2 = FactoryGirl.create(:sector, sector: "Banking")
    @business = Business.new(name: "My Business", country_id: @country.id, sector_id: @sector.id, created_by: 1)
  end
  
  subject { @business }
  
  it { should respond_to(:name) }
  it { should respond_to(:country_id) }
  it { should respond_to(:address_1) }
  it { should respond_to(:address_2) }
  it { should respond_to(:city) }
  it { should respond_to(:sector_id) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:registration_number) }
  it { should respond_to(:bank) }
  it { should respond_to(:bank_branch) }
  it { should respond_to(:iban) }
  it { should respond_to(:calendar_days) }
  it { should respond_to(:hours_per_day) }
  it { should respond_to(:hours_per_month) }
  it { should respond_to(:weekend_day_1) }
  it { should respond_to(:weekend_day_2) }
  it { should respond_to(:standard_ot_rate) }
  it { should respond_to(:supplementary_ot_rate) }
  it { should respond_to(:double_ot_rate) }
  it { should respond_to(:standard_start_time) }
  it { should respond_to(:autocalc_benefits) }
  it { should respond_to(:pension_scheme) }
  it { should respond_to(:bonus_provision) }
  it { should respond_to(:close_date) }
  it { should respond_to(:last_payroll_date) }
  it { should respond_to(:home_airport) }
  it { should respond_to(:review_interval) }
  it { should respond_to(:setup_complete) }
  
  it { should be_valid }
  
  describe "when name is blank" do
    before { @business.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @business.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate in the same country" do
    before do
      @duplicate = @business.dup
      @duplicate.sector_id = @sector_2.id
      @duplicate.name = @duplicate.name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate in a different country" do
    before do
      @duplicate = @business.dup
      @duplicate.country_id = @country_2.id
      @duplicate.save
    end
    it { should be_valid }
  end
  
  describe "when country_id is empty" do
    before { @business.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when sector_id is empty" do
    before { @business.sector_id = nil }
    it { should_not be_valid }
  end
  
  describe "when address_1 is too long" do
    before { @business.address_1 = "a" * 101 }
    it { should_not be_valid }
  end
  
  describe "when address_2 is too long" do
    before { @business.address_1 = "a" * 101 }
    it { should_not be_valid }
  end
  
  describe "when city is too long" do
    before { @business.city = "a" * 36 }
    it { should_not be_valid }
  end
  
  describe "when created_by is empty" do
    before { @business.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when hours_per_day is a decimal" do
    before { @business.hours_per_day = 8.5 }
    it { should be_valid }
  end
  
  describe "when hours_per_day is not a number" do
    before { @business.hours_per_day = "8 hrs" }
    it { should_not be_valid }
  end
  
  describe "when hours_per_day is blank" do
    before { @business.hours_per_day = nil }
    it { should_not be_valid }
  end
  
  describe "when hours_per_day is a negative" do
    before { @business.hours_per_day = -1 }
    it { should_not be_valid }
  end
  
  describe "when hours_per_month is a decimal" do
    before { @business.hours_per_month = 22.75 }
    it { should be_valid }
  end
  
  describe "when hours_per_month is not a number" do
    before { @business.hours_per_month = "200 hrs" }
    it { should_not be_valid }
  end
  
  describe "when hours_per_month is blank" do
    before { @business.hours_per_month = nil }
    it { should_not be_valid }
  end
  
  describe "when hours_per_month is a negative" do
    before { @business.hours_per_month = -1 }
    it { should_not be_valid }
  end
  
  describe "when weekend_day_1 is outside the 'Day' range" do
    before { @business.weekend_day_1 = 8 }
    it { should_not be_valid }
  end
  
  describe "when weekend_day_1 is 0" do
    before { @business.weekend_day_1 = 0 }
    it { should_not be_valid }
  end
  
  describe "when weekend_day_1 is blank" do
    before { @business.weekend_day_1 = nil }
    it { should_not be_valid }
  end
  
  describe "when weekend_day_2 is outside the 'Day' range" do
    before { @business.weekend_day_2 = 8 }
    it { should_not be_valid }
  end
  
  describe "when weekend_day_2 is 0" do
    before { @business.weekend_day_2 = 0 }
    it { should be_valid }
  end
  
  describe "when weekend_day_2 is blank" do
    before { @business.weekend_day_2 = nil }
    it { should_not be_valid }
  end
  
  describe "when registration_number is too long" do
    before { @business.registration_number = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when bank is too long" do
    before { @business.bank = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when bank is blank" do
    before { @business.bank = " " }
    it { should_not be_valid }
  end
  
  describe "when bank_branch is too long" do
    before { @business.bank_branch = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when bank_branch is blank" do
    before { @business.bank_branch = " " }
    it { should_not be_valid }
  end
  
  describe "when iban is too long" do
    before { @business.iban = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when iban is blank" do
    before { @business.iban = " " }
    it { should_not be_valid }
  end
  
  describe "when standard_ot_rate is blank" do
    before { @business.standard_ot_rate = nil }
    it { should_not be_valid }
  end
  
  describe "when standard_ot_rate is not a number" do
    before { @business.standard_ot_rate = "Time and a quarter" }
    it { should_not be_valid }
  end
  
  describe "when standard_ot_rate is outside the permitted range" do
    before { @business.standard_ot_rate = 2.1 }
    it { should_not be_valid }
  end
  
  describe "when supplementary_ot_rate is blank" do
    before { @business.supplementary_ot_rate = nil }
    it { should_not be_valid }
  end
  
  describe "when supplementary_ot_rate is not a number" do
    before { @business.supplementary_ot_rate = "Time and a half" }
    it { should_not be_valid }
  end
  
  describe "when supplementary_ot_rate is outside the permitted range" do
    before { @business.standard_ot_rate = -0.5 }
    it { should_not be_valid }
  end
  
  describe "when double_ot_rate is blank" do
    before { @business.double_ot_rate = nil }
    it { should_not be_valid }
  end
  
  describe "when standard_ot_rate is not a number" do
    before { @business.double_ot_rate = "Double" }
    it { should_not be_valid }
  end
  
  describe "when double_ot_rate is outside the permitted range" do
    before { @business.double_ot_rate = 3.1 }
    it { should_not be_valid }
  end
  
  describe "standard_start_time is blank" do
    before { @business.standard_start_time = nil }
    it { should_not be_valid }
  end
  
  describe "minutes greater than one hour in start-time" do
    before { @business.standard_start_time = "11:63" }
    it { should_not be_valid }
  end
  
  describe "one-digit minutes in start-time" do
    before { @business.standard_start_time = "11:3" }
    it { should_not be_valid }
  end
  
  describe "24 hours shown in start-time" do
    before { @business.standard_start_time = "25:01" }
    it { should_not be_valid }
  end
  
  describe "colon not used in start-time" do
    before { @business.standard_start_time = "21;00" }
    it { should_not be_valid }
  end
  
  describe "one-digit hour in start-time" do
    before { @business.standard_start_time = "9:53" }
    it { should be_valid }
  end
  
  describe "close_date is blank" do
    before { @business.close_date = nil }
    it { should_not be_valid }
  end
  
  describe "close_date > 27" do
    before { @business.close_date = 28 }
    it { should_not be_valid }
  end
  
  describe "close_date < 10" do
    before { @business.close_date = 9 }
    it { should_not be_valid }
  end
  
  describe "close_date is not a number" do
    before { @business.close_date = "Thursday" }
    it { should_not be_valid }
  end
  
  describe "close_date is not an integer" do
    before { @business.close_date = "15/11" }
    it { should_not be_valid }
  end
  
  describe "home_airport is blank" do
    before { @business.home_airport = "" }
    it { should be_valid }
  end
  
  describe "home_airport is too long" do
    before { @business.home_airport = "a" * 36 }
    it { should_not be_valid }
  end
  
  describe "review_interval is blank" do
    before { @business.review_interval = nil }
    it { should_not be_valid }
  end
  
  describe "review_interval > 12" do
    before { @business.review_interval = 13 }
    it { should_not be_valid }
  end
  
  describe "review_interval is a decimal" do
    before { @business.review_interval = 2.5 }
    it { should_not be_valid }
  end
  
  describe "review_interval is not a number" do
    before { @business.review_interval = "Six months" }
    it { should_not be_valid }
  end
  
end
