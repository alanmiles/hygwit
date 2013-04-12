# == Schema Information
#
# Table name: advance_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_by :integer          default(1)
#  checked    :boolean          default(FALSE)
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe AdvanceType do
  before do
    @advance = AdvanceType.new(name: 'Personal')
  end
  
  subject { @advance }

  it { should respond_to(:name) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when name is not present" do
    before { @advance.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is nil" do
    before { @advance.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @advance.name = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when name is a duplicate" do
    before do
      @duplicate = @advance.dup
      @duplicate.name.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @advance.created_by = nil }
    it { should_not be_valid }
  end
end
