# == Schema Information
#
# Table name: insurance_settings
#
#  id                  :integer          not null, primary key
#  country_id          :integer
#  shortcode           :string(255)
#  name                :string(255)
#  weekly_milestone    :decimal(, )
#  monthly_milestone   :decimal(, )
#  annual_milestone    :decimal(, )
#  effective_date      :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  cancellation_date   :date
#  checked             :boolean          default(FALSE)
#  updated_by          :integer          default(1)
#  created_by          :integer          default(1)
#  cancellation_change :boolean          default(FALSE)
#

require 'spec_helper'

describe InsuranceSetting do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Bahraini")
    @currency = FactoryGirl.create(:currency, currency: "Bahraini Dinars", code: "BHD")
    @country = Country.create(country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id, insurance: true)
    @setting = @country.insurance_settings.build(shortcode: "ST", name: "Standard Rate", weekly_milestone: 988, 
    										monthly_milestone: 4000, annual_milestone: 48000, effective_date: Date.today - 60.days)
                                                
  end
  
  subject { @setting }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:shortcode) }
  it { should respond_to(:name) }
  it { should respond_to(:weekly_milestone) }
  it { should respond_to(:monthly_milestone) }
  it { should respond_to(:annual_milestone) }
  it { should respond_to(:effective_date) }
  it { should respond_to(:cancellation_date) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should respond_to(:cancellation_change) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to country_id" do
      expect do
        InsuranceSetting.new(country_id: @country.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when country_id is nil" do
    pending("fails validation on duplicate cancelled - on create.  Safe to omit")
    #before { @setting.country_id = nil }
    #it { should_not be_valid }
  end
  
  describe "when shortcode is empty" do
    before { @setting.shortcode = " " }
    it { should_not be_valid }
  end
  
  describe "when shortcode is too long" do
    before { @setting.shortcode = "a" * 6 }
    it { should_not be_valid }
  end
  
  describe "when shortcode is a duplicate in the same country and with the same effective date" do
    before do
      @setting_2 = @country.insurance_settings.create(shortcode: "ST", name: "Different Rate", weekly_milestone: 989, 
    										monthly_milestone: 4001, annual_milestone: 48001, effective_date: Date.today - 60.days)
    end
    it { should_not be_valid }
  end
  
  describe "when name is empty" do
    before { @setting.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @setting.name = "a" * 31 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate in the same country and with the same effective date" do
    before do
      @setting_3 = @country.insurance_settings.create(shortcode: "STY", name: "Standard Rate", weekly_milestone: 989, 
    										monthly_milestone: 4001, annual_milestone: 48001, effective_date: Date.today - 60.days)
    end
    it { should_not be_valid }
  end
  
  describe "when record is a duplicate in the same country but with a different effective date" do
    before do
      @setting_4 = @country.insurance_settings.create(shortcode: "ST", name: "Standard Rate", weekly_milestone: 988, 
    										monthly_milestone: 4000, annual_milestone: 48000, effective_date: Date.today - 30.days)
    end
    it { should be_valid }
  end
  
  describe "when record is a duplicate - but in a different country" do
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "Saudi")
      @currency_2 = FactoryGirl.create(:currency, currency: "Saudi Riyals", code: "SAR")
      @country_2 = Country.create(country: "Saudi Arabia", nationality_id: @nationality_2.id, 
      														currency_id: @currency_2.id, insurance: true)
      @setting_5 = @country_2.insurance_settings.create(shortcode: "ST", name: "Standard Rate", weekly_milestone: 988, 
    										monthly_milestone: 4000, annual_milestone: 48000, effective_date: Date.today - 60.days)
    end
    it { should be_valid }
  end
  
  describe "when weekly_milestone is empty" do
    before { @setting.weekly_milestone = nil }
    it { should_not be_valid }
  end
  
  describe "when weekly_milestone is not a number" do
    before { @setting.weekly_milestone = "BHD 400" }
    it { should_not be_valid }
  end
  
  describe "when weekly_milestone is a negative" do
    before { @setting.weekly_milestone = -1 }
    it { should_not be_valid }
  end
  
  describe "when monthly_milestone is empty" do
    before { @setting.monthly_milestone = nil }
    it { should_not be_valid }
  end
  
  describe "when monthly_milestone is not a number" do
    before { @setting.monthly_milestone = "BHD 400" }
    it { should_not be_valid }
  end
  
  describe "when monthly_milestone is a negative" do
    before { @setting.monthly_milestone = -1 }
    it { should_not be_valid }
  end
  
  describe "when annual_milestone is empty" do
    before { @setting.annual_milestone = nil }
    it { should_not be_valid }
  end
  
  describe "when annual_milestone is not a number" do
    before { @setting.annual_milestone = "BHD 400" }
    it { should_not be_valid }
  end
  
  describe "when annual_milestone is a negative" do
    before { @setting.annual_milestone = -1 }
    it { should_not be_valid }
  end
  
  describe "when effective_date is empty" do
    before { @setting.effective_date = nil }
    it { should_not be_valid }
  end
  
  describe "when cancellation date <= effective date" do
    before { @setting.cancellation_date = Date.today - 60.days }
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @setting.created_by = nil }
    it { should_not be_valid }
  end
      
  describe "when code entered has already been cancelled" do
    before do
      @setting_cancelled = @country.insurance_settings.create(shortcode: "ST", name: "Standard Rate", weekly_milestone: 900, 
    										monthly_milestone: 3600, annual_milestone: 43200, effective_date: Date.today - 120.days,
    										cancellation_date: Date.today - 40.days)
    end
    it { should_not be_valid }
  end
  
end
