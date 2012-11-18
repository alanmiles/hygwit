# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  contract   :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Contract do
  
  before do
    @contract = Contract.new(contract: 'Full-time')
  end
  
  subject { @contract }

  it { should respond_to(:contract) }
  it { should be_valid }
  
  describe "when contract is not present" do
    before { @contract.contract = " " }
    it { should_not be_valid }
  end
  
  describe "when contract is nil" do
    before { @contract.contract = nil }
    it { should_not be_valid }
  end
  
  describe "when contract is too long" do
    before { @contract.contract = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when contract is a duplicate" do
    before do
      @duplicate = @contract.dup
      @duplicate.contract.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
end
