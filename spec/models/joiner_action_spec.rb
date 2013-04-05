# == Schema Information
#
# Table name: joiner_actions
#
#  id             :integer          not null, primary key
#  action         :string(255)
#  contract       :integer          default(2)
#  residence      :integer          default(2)
#  nationality    :integer          default(2)
#  marital_status :integer          default(2)
#  position       :integer
#  created_by     :integer          default(1)
#  checked        :boolean          default(FALSE)
#  updated_by     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe JoinerAction do
  before do
    @action = JoinerAction.new(action: 'Hire Employee')
  end
  
  subject { @action }

  it { should respond_to(:action) }
  it { should respond_to(:contract) }
  it { should respond_to(:residence) }
  it { should respond_to(:nationality) }
  it { should respond_to(:marital_status) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when 'action' is not present" do
    before { @action.action = " " }
    it { should_not be_valid }
  end
  
  describe "when 'action' is nil" do
    before { @action.action = nil }
    it { should_not be_valid }
  end
  
  describe "when 'action' is too long" do
    before { @action.action = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when 'action' is a duplicate" do
    before do
      @duplicate = @action.dup
      @duplicate.action.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when created_by is missing" do
    before { @action.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when created_by is not an integer" do
    before { @action.created_by = "Alan" }
    it { should_not be_valid }
  end
  
  describe "when contract is empty" do
    before { @action.contract = nil }
    it { should_not be_valid } 
  end  
  
  describe "when contract is not within permitted range 0-2" do
    before { @action.contract = 3 }
    it { should_not be_valid } 
  end
  
  describe "when contract is not an integer" do
    before { @action.contract = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when nationality is empty" do
    before { @action.nationality = nil }
    it { should_not be_valid } 
  end  
  
  describe "when nationality is not within permitted range 0-2" do
    before { @action.nationality = 3 }
    it { should_not be_valid } 
  end
  
  describe "when nationality is not an integer" do
    before { @action.nationality = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when residence is empty" do
    before { @action.residence = nil }
    it { should_not be_valid } 
  end  
  
  describe "when residence is not within permitted range 0-2" do
    before { @action.residence = 3 }
    it { should_not be_valid } 
  end
  
  describe "when residence is not an integer" do
    before { @action.residence = "Yes" }
    it { should_not be_valid } 
  end
  
  describe "when marital_status is empty" do
    before { @action.marital_status = nil }
    it { should_not be_valid } 
  end  
  
  describe "when marital_status is not within permitted range 0-2" do
    before { @action.marital_status = 3 }
    it { should_not be_valid } 
  end
  
  describe "when marital_status is not an integer" do
    before { @action.marital_status = "Yes" }
    it { should_not be_valid } 
  end
end
