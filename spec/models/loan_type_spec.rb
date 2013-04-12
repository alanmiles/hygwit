# == Schema Information
#
# Table name: loan_types
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  qualifying_months     :integer          default(12)
#  max_repayment_months  :integer          default(12)
#  max_salary_multiplier :integer          default(12)
#  max_amount            :integer          default(1000)
#  apr                   :decimal(4, 2)    default(0.0)
#  created_by            :integer          default(1)
#  checked               :boolean          default(FALSE)
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe LoanType do
  before do
    @loan = LoanType.new(name: 'Personal')
  end
  
  subject { @loan }

  it { should respond_to(:name) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should respond_to(:qualifying_months) }
  it { should respond_to(:max_repayment_months) }
  it { should respond_to(:max_salary_multiplier) }
  it { should respond_to(:max_amount) }
  it { should respond_to(:apr) }
  it { should be_valid }
  
  describe "when name is not present" do
    before { @loan.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is nil" do
    before { @loan.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @loan.name = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate" do
    before do
      @duplicate = @loan.dup
      @duplicate.name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when qualifying months is empty" do
    before { @loan.qualifying_months = nil }
    it { should_not be_valid }
  end
    
  describe "when qualifying months is not an integer" do
    before { @loan.qualifying_months = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when qualifying months is a negative" do
    before { @loan.qualifying_months = -3 }
    it { should_not be_valid }
  end
  
  describe "when qualifying months is not a number" do
    before { @loan.qualifying_months = "Three" }
    it { should_not be_valid }
  end
   
  describe "when max repayment months is empty" do
    before { @loan.max_repayment_months = nil }
    it { should_not be_valid }
  end
    
  describe "when max_repayment_months is not an integer" do
    before { @loan.max_repayment_months = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_repayment_months is a negative" do
    before { @loan.max_repayment_months = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_repayment_months is not a number" do
    before { @loan.max_repayment_months = "Three" }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is empty" do
    before { @loan.max_salary_multiplier = nil }
    it { should_not be_valid }
  end
    
  describe "when max_salary_multiplier is not an integer" do
    before { @loan.max_salary_multiplier = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is a negative" do
    before { @loan.max_salary_multiplier = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is not a number" do
    before { @loan.max_salary_multiplier = "Three" }
    it { should_not be_valid }
  end
  
  describe "when max_amount is empty" do
    before { @loan.max_amount = nil }
    it { should_not be_valid }
  end
    
  describe "when max_amount is not an integer" do
    before { @loan.max_amount = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_amount is a negative" do
    before { @loan.max_amount = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_amount is not a number" do
    before { @loan.max_amount = "Three" }
    it { should_not be_valid }
  end
  
  describe "when apr is empty" do
    before { @loan.apr = nil }
    it { should_not be_valid }
  end
    
  describe "when apr is not an integer" do
    before { @loan.apr = 3.5 }
    it { should be_valid }
  end
  
  describe "when apr is a negative" do
    before { @loan.apr = -3 }
    it { should_not be_valid }
  end
  
  describe "when apr is not a number" do
    before { @loan.apr = "Three" }
    it { should_not be_valid }
  end
  
  describe "when apr >100" do
    before { @loan.apr = 101 }
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @loan.created_by = nil }
    it { should_not be_valid }
  end
end
