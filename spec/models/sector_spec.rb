# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  sector     :string(255)
#  created_by :integer
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Sector do
  
  before do
    @sector = Sector.new(sector: 'Banking', created_by: 1)
  end
  
  subject { @sector }

  it { should respond_to(:sector) }
  it { should respond_to(:approved) }
  it { should respond_to(:created_by) }
  it { should be_valid }
  
  describe "when sector is not present" do
    before { @sector.sector = " " }
    it { should_not be_valid }
  end
  
  describe "when sector is nil" do
    before { @sector.sector = nil }
    it { should_not be_valid }
  end
  
  describe "when sector is too long" do
    before { @sector.sector = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when sector is a duplicate" do
    before do
      @duplicate = @sector.dup
      @duplicate.sector.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @sector.created_by = nil }
    it { should_not be_valid }
  end
end
