# == Schema Information
#
# Table name: nationalities
#
#  id          :integer          not null, primary key
#  nationality :string(255)
#  created_by  :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  checked     :boolean          default(FALSE)
#  updated_by  :integer          default(1)
#

require 'spec_helper'

describe Nationality do
  
  before do
    @nationality = Nationality.new(nationality: 'British')
  end
  
  subject { @nationality }

  it { should respond_to(:nationality) }
  it { should respond_to(:checked) }
  it { should respond_to(:updated_by) }
  
  it { should be_valid }
  
  describe "when nationality is not present" do
    before { @nationality.nationality = " " }
    it { should_not be_valid }
  end
  
  describe "when nationality is nil" do
    before { @nationality.nationality = nil }
    it { should_not be_valid }
  end
  
  describe "when nationality is too long" do
    before { @nationality.nationality = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when nationality is a duplicate" do
    before do
      @duplicate = @nationality.dup
      @duplicate.nationality.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
end
