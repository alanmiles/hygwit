# == Schema Information
#
# Table name: insurance_codes
#
#  id             :integer          not null, primary key
#  country_id     :integer
#  insurance_code :string(255)
#  explanation    :string(255)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer          default(1)
#  cancelled      :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  created_by     :integer          default(1)
#

require 'spec_helper'

describe InsuranceCode do
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Bahraini")
    @currency = FactoryGirl.create(:currency, currency: "Bahraini Dinars", code: "BHD")
    @country = Country.create(country: "Bahrain", nationality_id: @nationality.id, currency_id: @currency.id)
    @code = @country.insurance_codes.build(insurance_code: "A", explanation: "Default employee")
  end
  
  subject { @code }
  
  it { should respond_to(:country_id) }
  its(:country) { should == @country }
  it { should respond_to(:insurance_code) }
  it { should respond_to(:explanation) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:cancelled) }
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
    before { @code.country_id = nil }
    it { should_not be_valid }
  end
  
  describe "when insurance_code is empty" do
    before { @code.insurance_code = " " }
    it { should_not be_valid }
  end
  
  describe "when insurance_code is too long" do
    before { @code.insurance_code = "a"*6 }
    it { should_not be_valid }
  end
  
  describe "when insurance_code is a duplicate in the same country" do
    before do
      @country.insurance_codes.create(insurance_code: "a", explanation: "Another type")
    end
    it { should_not be_valid }
  end
  
  describe "when explanation is empty" do
    before { @code.explanation = " " }
    it { should_not be_valid }
  end
  
  describe "when explanation is too long" do
    before { @code.explanation = "a"*51 }
    it { should_not be_valid }
  end
  
  describe "when explanation is a duplicate in the same country" do
    before do
      @country.insurance_codes.create(insurance_code: "B", explanation: "default Employee")
    end
    it { should_not be_valid }
  end
  
  describe "when created_by is nil" do
    before { @code.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when created_by is not a number" do
    before { @code.created_by = "Alan" }
    it { should_not be_valid }
  end
  
  describe "when working with similar data in another country" do
    before do
      @nationality_2 = FactoryGirl.create(:nationality, nationality: "Saudi")
      @currency_2 = FactoryGirl.create(:currency, currency: "Saudi Riyals", code: "SAR")
      @country_2 = Country.create(country: "Saudi Arabia", nationality_id: @nationality_2.id, currency_id: @currency_2.id)
      @country_2.insurance_codes.create(insurance_code: "A", explanation: "Default employee")
    end
    it { should be_valid }
  end
end
