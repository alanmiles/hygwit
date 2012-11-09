# == Schema Information
#
# Table name: absence_types
#
#  id                     :integer          not null, primary key
#  absence_code           :string(255)
#  paid                   :integer          default(100)
#  sickness               :boolean          default(FALSE)
#  maximum_days_year      :integer
#  documentation_required :boolean          default(TRUE)
#  notes                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe AbsenceType do
  
  before do
    @absence = AbsenceType.new(absence_code: "SF", sickness: true, maximum_days_year: 15, notes: "Sickness on full pay")
  end
  
  subject { @absence }
  
  it { should respond_to(:absence_code) }
  it { should respond_to(:paid) }
  it { should respond_to(:sickness) }
  it { should respond_to(:maximum_days_year) }
  it { should respond_to(:documentation_required) }
  it { should respond_to(:notes) }
  
  it { should be_valid }
  
  describe "when absence_code is blank" do
    before { @absence.absence_code = " " }
    it { should_not be_valid }
  end
  
  describe "when absence_code is nil" do
    before { @absence.absence_code = nil }
    it { should_not be_valid }
  end
  
  describe "when absence_code is too long" do
    before { @absence.absence_code = "a" * 5 }
    it { should_not be_valid }
  end
  
  describe "when absence_code is a duplicate" do
    before do
      duplicate = @absence.dup
      duplicate.absence_code.downcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when paid is not a number" do
    before { @absence.paid = "Yes" }
    it { should_not be_valid }
  end
  
  describe "when paid > 100" do
    before { @absence.paid = 101 }
    it { should_not be_valid }
  end  
    
  describe "when paid < 0" do
    before { @absence.paid = -1 }
    it { should_not be_valid }
  end
  
  describe "when paid is not an integer" do
    before { @absence.paid = 50.5 }
    it { should_not be_valid }
  end
  
  describe "when paid is blank" do
    before { @absence.paid = nil }
    it { should_not be_valid }
  end
  
  describe "when sickness is FALSE" do
    before { @absence.sickness = false }
    it { should be_valid }
  end
  
  describe "when maximum_days_year is empty" do
    before { @absence.maximum_days_year = nil }
    it { should be_valid }
  end
  
  describe "when maximum_days_year is not a number" do
    before { @absence.maximum_days_year = "One" }
    it { should_not be_valid }
  end
  
  describe "when maximum_days_year is not an integer" do
    before { @absence.maximum_days_year = 12.5 }
    it { should_not be_valid }
  end
  
  describe "when maximum_days_year is a negative value" do
    before { @absence.maximum_days_year = -1 }
    it { should_not be_valid }
  end
  
  describe "when notes is empty" do
    before { @absence.notes = " " }
    it { should be_valid }
  end
  
  describe "when notes is nil" do
    before { @absence.notes = nil }
    it { should be_valid }
  end
  
  describe "when notes is too long" do
    before { @absence.notes = "a" * 141 }
    it { should_not be_valid }
  end
end
