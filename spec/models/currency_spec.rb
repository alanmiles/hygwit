# == Schema Information
#
# Table name: currencies
#
#  id             :integer          not null, primary key
#  currency       :string(255)
#  code           :string(255)
#  created_by     :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  decimal_places :integer          default(2)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer          default(1)
#

require 'spec_helper'

describe Currency do
  
  before do
    @currency = Currency.new(currency: 'Pound Sterling', code: 'GBP')
  end
  
  subject { @currency }

  it { should respond_to(:currency) }
  it { should respond_to(:code) }
  it { should respond_to(:decimal_places) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  it { should be_valid }
  
  describe "when currency is not present" do
    before { @currency.currency = " " }
    it { should_not be_valid }
  end
  
  describe "when currency is nil" do
    before { @currency.currency = nil }
    it { should_not be_valid }
  end
  
  describe "when currency is too long" do
    before { @currency.currency = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when code is not present" do
    before { @currency.code = " " }
    it { should_not be_valid }
  end
  
  describe "when code is nil" do
    before { @currency.code = nil }
    it { should_not be_valid }
  end
  
  describe "when code is too long" do
    before { @currency.code = "a" * 4 }
    it { should_not be_valid }
  end
  
  describe "when code is a duplicate" do
    before do
      @duplicate = @currency.dup
      @duplicate.code.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when decimal_places is nil" do
    before { @currency.decimal_places = nil }
    it { should_not be_valid }
  end
    
  describe "when decimal_places is not a numeral" do
    before { @currency.decimal_places = "Two" }
    it { should_not be_valid }
  end
end
