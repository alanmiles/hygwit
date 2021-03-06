# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  business_id :integer
#  department  :string(255)
#  dept_code   :string(255)
#  division_id :integer
#  current     :boolean          default(TRUE)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Department do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @division = @business.divisions.create(division: "Div")
    @department = @business.departments.build(department: "Dept B", dept_code: "DPTB", division_id: @division.id)
  end
  
  
  subject { @department }
  
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:division_id) }
  it { should respond_to(:department) }
  it { should respond_to(:dept_code) }
  it { should respond_to(:current) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        Department.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @department.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when division_id is nil" do
    before { @department.division_id = nil }
    it { should_not be_valid }
  end
  
  describe "when division_id is not an integer" do
    before { @department.division_id = "ABC" }
    it { should_not be_valid }
  end
  
  describe "when department field is blank" do
    before { @department.department = " " }
    it { should_not be_valid }
  end
  
  describe "when department field is nil" do
    before { @department.department = nil }
    it { should_not be_valid }
  end
  
  describe "when department field is too long" do
    before { @department.department = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when dept_code is blank" do
    before { @department.dept_code = " " }
    it { should_not be_valid }
  end
  
  describe "when dept_code field is nil" do
    before { @department.dept_code = nil }
    it { should_not be_valid }
  end
  
  describe "when dept_code field is too long" do
    before { @department.dept_code = "a" * 6 }
    it { should_not be_valid }
  end
  
  describe "when department is a duplicate (for business)" do
    before do
      duplicate = @department.dup
      duplicate.dept_code = "DPTC"
      duplicate.department = duplicate.department.upcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when dept_code is a duplicate (for business)" do
    before do
      duplicate = @department.dup
      duplicate.department = "Dept C"
      duplicate.dept_code = duplicate.dept_code.downcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when department and dept_code are duplicates but for another business" do
    before do
      @business_2 = @business.dup
      @business_2.name = "Business Foo"
      @business_2.save      
      non_dup = @business_2.departments.create(department: "Dept B", dept_code: "DPTB", division_id: @division.id)
    end
    it { should be_valid }  
  end
end
