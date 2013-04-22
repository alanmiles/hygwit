# == Schema Information
#
# Table name: leaving_reasons
#
#  id            :integer          not null, primary key
#  reason        :string(255)
#  full_benefits :boolean          default(FALSE)
#  created_by    :integer          default(1)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  checked       :boolean          default(FALSE)
#  updated_by    :integer          default(1)
#

require 'spec_helper'

describe LeavingReason do
  
  before do
    @leaving_reason = LeavingReason.new(reason: 'Resigned')
  end
  
  subject { @leaving_reason }

  it { should respond_to(:reason) }
  it { should respond_to(:full_benefits) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  
  it { should be_valid }
  
  describe "when reason is not present" do
    before { @leaving_reason.reason = " " }
    it { should_not be_valid }
  end
  
  describe "when reason is nil" do
    before { @leaving_reason.reason = nil }
    it { should_not be_valid }
  end
  
  describe "when reason is too long" do
    before { @leaving_reason.reason = "a" * 26 }
    it { should_not be_valid }
  end
  
  describe "when reason is a duplicate" do
    before do
      @duplicate = @leaving_reason.dup
      @duplicate.reason.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
end
