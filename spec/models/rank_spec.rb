# == Schema Information
#
# Table name: ranks
#
#  id         :integer          not null, primary key
#  rank       :string(255)
#  position   :integer
#  created_by :integer          default(1)
#  checked    :boolean          default(FALSE)
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Rank do
  before do
    @rank = Rank.new(rank: 'Senior Managers')
  end
  
  subject { @rank }

  it { should respond_to(:rank) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  it { should be_valid }
  
  describe "when rank-name is not present" do
    before { @rank.rank = " " }
    it { should_not be_valid }
  end
  
  describe "when rank is nil" do
    before { @rank.rank = nil }
    it { should_not be_valid }
  end
  
  describe "when rank is too long" do
    before { @rank.rank = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when rank is a duplicate" do
    before do
      @duplicate = @rank.dup
      @duplicate.rank.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when created_by is missing" do
    before { @rank.created_by = nil }
    it { should_not be_valid }
  end
  
  describe "when created_by is not an integer" do
    before { @rank.created_by = "Alan" }
    it { should_not be_valid }
  end  
end
