# == Schema Information
#
# Table name: loan_cats
#
#  id                    :integer          not null, primary key
#  business_id           :integer
#  name                  :string(255)
#  qualifying_months     :integer          default(12)
#  max_repayment_months  :integer          default(12)
#  max_salary_multiplier :integer          default(12)
#  max_amount            :integer          default(1000)
#  apr                   :decimal(4, 2)    default(0.0)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe LoanCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @loan_type = FactoryGirl.create(:loan_type, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @loan_cat = @business.loan_cats.build(name: "Private")
  end
  
  subject { @loan_cat }

  it { should respond_to(:name) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:qualifying_months) }
  it { should respond_to(:max_repayment_months) }
  it { should respond_to(:max_salary_multiplier) }
  it { should respond_to(:max_amount) }
  it { should respond_to(:apr) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        LoanCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @loan_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @loan_cat.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is nil" do
    before { @loan_cat.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @loan_cat.name = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate for the same business" do
    before do
      @duplicate = @loan_cat.dup
      @duplicate.name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @loan_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
   
  describe "when qualifying months is empty" do
    before { @loan_cat.qualifying_months = nil }
    it { should_not be_valid }
  end
    
  describe "when qualifying months is not an integer" do
    before { @loan_cat.qualifying_months = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when qualifying months is a negative" do
    before { @loan_cat.qualifying_months = -3 }
    it { should_not be_valid }
  end
  
  describe "when qualifying months is not a number" do
    before { @loan_cat.qualifying_months = "Three" }
    it { should_not be_valid }
  end
   
  describe "when max repayment months is empty" do
    before { @loan_cat.max_repayment_months = nil }
    it { should_not be_valid }
  end
    
  describe "when max_repayment_months is not an integer" do
    before { @loan_cat.max_repayment_months = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_repayment_months is a negative" do
    before { @loan_cat.max_repayment_months = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_repayment_months is not a number" do
    before { @loan_cat.max_repayment_months = "Three" }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is empty" do
    before { @loan_cat.max_salary_multiplier = nil }
    it { should_not be_valid }
  end
    
  describe "when max_salary_multiplier is not an integer" do
    before { @loan_cat.max_salary_multiplier = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is a negative" do
    before { @loan_cat.max_salary_multiplier = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_salary_multiplier is not a number" do
    before { @loan_cat.max_salary_multiplier = "Three" }
    it { should_not be_valid }
  end
  
  describe "when max_amount is empty" do
    before { @loan_cat.max_amount = nil }
    it { should_not be_valid }
  end
    
  describe "when max_amount is not an integer" do
    before { @loan_cat.max_amount = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when max_amount is a negative" do
    before { @loan_cat.max_amount = -3 }
    it { should_not be_valid }
  end
  
  describe "when max_amount is not a number" do
    before { @loan_cat.max_amount = "Three" }
    it { should_not be_valid }
  end
  
  describe "when apr is empty" do
    before { @loan_cat.apr = nil }
    it { should_not be_valid }
  end
    
  describe "when apr is not an integer" do
    before { @loan_cat.apr = 3.5 }
    it { should be_valid }
  end
  
  describe "when apr is a negative" do
    before { @loan_cat.apr = -3 }
    it { should_not be_valid }
  end
  
  describe "when apr is not a number" do
    before { @loan_cat.apr = "Three" }
    it { should_not be_valid }
  end
  
  describe "when apr >100" do
    before { @loan_cat.apr = 101 }
    it { should_not be_valid }
  end
end
