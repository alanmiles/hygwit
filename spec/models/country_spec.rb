# == Schema Information
#
# Table name: countries
#
#  id                     :integer          not null, primary key
#  country                :string(255)
#  nationality_id         :integer
#  currency_id            :integer
#  taxation               :boolean          default(FALSE)
#  insurance              :boolean          default(TRUE)
#  probation_days         :integer          default(90)
#  max_hours_day          :integer          default(9)
#  max_hours_week         :integer          default(45)
#  max_hours_day_ramadan  :integer          default(6)
#  max_hours_week_ramadan :integer          default(30)
#  sickness_accruals      :boolean          default(FALSE)
#  retirement_age_m       :integer          default(60)
#  retirement_age_f       :integer          default(55)
#  OT_rate_standard       :decimal(3, 2)
#  OT_rate_special        :decimal(3, 2)
#  nightwork_start        :time
#  nightwork_end          :time
#  max_loan_ded_salary    :integer          default(15)
#  notes                  :text
#  complete               :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Country do
  
  before do
    @nationality = FactoryGirl.create(:nationality)
    @currency = FactoryGirl.create(:currency)
    @country = Country.new(country: "Qatar", nationality_id: @nationality.id, currency_id: @currency.id)
  end
  
  subject { @country }
  
  it { should respond_to(:country) }
  it { should respond_to(:nationality_id) }
  it { should respond_to(:currency_id) }
  it { should respond_to(:taxation) }
  it { should respond_to(:complete) }
  
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
end