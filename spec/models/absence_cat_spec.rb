# == Schema Information
#
# Table name: absence_cats
#
#  id                     :integer          not null, primary key
#  business_id            :integer
#  absence_code           :string(255)
#  paid                   :integer          default(100)
#  sickness               :boolean          default(FALSE)
#  maximum_days_year      :integer
#  documentation_required :boolean          default(TRUE)
#  notes                  :string(255)
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe AbsenceCat do
  
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @country_absence = FactoryGirl.create(:country_absence, country_id: @country.id, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @absence_cat = @business.absence_cats.build(absence_code: "CS", created_by: 1)
  end
  
  subject { @absence_cat }
  
  it { should respond_to(:business_id) }
  its(:business) { should == @business }
  it { should respond_to(:absence_code) }
  it { should respond_to(:paid) }
  it { should respond_to(:sickness) }
  it { should respond_to(:maximum_days_year) }
  it { should respond_to(:documentation_required) }
  it { should respond_to(:notes) }
  it { should respond_to(:created_by) } 
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to business_id" do
      expect do
        AbsenceCat.new(business_id: @business.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when business_id is nil" do
    before { @absence_cat.business_id = nil }
    it { should_not be_valid }
  end
  
  describe "when absence_code is blank" do
    before { @absence_cat.absence_code = " " }
    it { should_not be_valid }
  end
  
  describe "when absence_code is nil" do
    before { @absence_cat.absence_code = nil }
    it { should_not be_valid }
  end
  
  describe "when absence_code is too long" do
    before { @absence_cat.absence_code = "a" * 5 }
    it { should_not be_valid }
  end
  
  describe "when absence_code is a duplicate" do
    before do
      duplicate = @absence_cat.dup
      duplicate.absence_code.downcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when paid is not a number" do
    before { @absence_cat.paid = "Yes" }
    it { should_not be_valid }
  end
  
  describe "when paid > 100" do
    before { @absence_cat.paid = 101 }
    it { should_not be_valid }
  end  
    
  describe "when paid < 0" do
    before { @absence_cat.paid = -1 }
    it { should_not be_valid }
  end
  
  describe "when paid is not an integer" do
    before { @absence_cat.paid = 50.5 }
    it { should_not be_valid }
  end
  
  describe "when paid is blank" do
    before { @absence_cat.paid = nil }
    it { should_not be_valid }
  end
  
  describe "when sickness is FALSE" do
    before { @absence_cat.sickness = false }
    it { should be_valid }
  end
  
  describe "when maximum_days_year is empty" do
    before { @absence_cat.maximum_days_year = nil }
    it { should be_valid }
  end
  
  describe "when maximum_days_year is not a number" do
    before { @absence_cat.maximum_days_year = "One" }
    it { should_not be_valid }
  end
  
  describe "when maximum_days_year is not an integer" do
    before { @absence_cat.maximum_days_year = 12.5 }
    it { should_not be_valid }
  end
  
  describe "when maximum_days_year is a negative value" do
    before { @absence_cat.maximum_days_year = -1 }
    it { should_not be_valid }
  end
  
  describe "when notes is empty" do
    before { @absence_cat.notes = " " }
    it { should be_valid }
  end
  
  describe "when notes is nil" do
    before { @absence_cat.notes = nil }
    it { should be_valid }
  end
  
  describe "when notes is too long" do
    before { @absence_cat.notes = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "when created_by is empty" do
    before { @absence_cat.created_by = nil }
    it { should be_valid }
  end
  
end
