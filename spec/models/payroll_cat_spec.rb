# == Schema Information
#
# Table name: payroll_cats
#
#  id          :integer          not null, primary key
#  business_id :integer
#  category    :string(255)
#  description :string(255)
#  on_payslip  :boolean          default(FALSE)
#  position    :integer
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe PayrollCat do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @pay_cat = FactoryGirl.create(:pay_category, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @payroll_cat = @business.payroll_cats.build(category: "Accruals")
  end
  
  subject { @payroll_cat }

  it { should respond_to(:category) }
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:description) }
  it { should respond_to(:on_payslip) }
  it { should respond_to(:position) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        PayrollCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @payroll_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when category is not present" do
    before { @payroll_cat.category = " " }
    it { should_not be_valid }
  end
  
  describe "when category is nil" do
    before { @payroll_cat.category = nil }
    it { should_not be_valid }
  end
  
  describe "when category is too long" do
    before { @payroll_cat.category = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when category is a duplicate for the same business" do
    before do
      @duplicate = @payroll_cat.dup
      @duplicate.category.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when category is a duplicate but for a different business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save
      @non_duplicate = @payroll_cat.dup
      @non_duplicate.business_id = @business_2.id
      @non_duplicate.save
    end
    it { should be_valid }
  end
  
  describe "when description is left empty" do
    before { @payroll_cat.description = nil }
    it { should be_valid }
  end
  
  describe "when description is too long" do
    before { @payroll_cat.description = "a" * 255 }
    it { should_not be_valid }
  end
end
