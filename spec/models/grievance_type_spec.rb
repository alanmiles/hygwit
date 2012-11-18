# == Schema Information
#
# Table name: grievance_types
#
#  id         :integer          not null, primary key
#  grievance  :string(255)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe GrievanceType do
  
  before do
    @grievance_type = GrievanceType.new(grievance: 'Bullying')
  end
  
  subject { @grievance_type }

  it { should respond_to(:grievance) }
  it { should be_valid }
  
  describe "when grievance is not present" do
    before { @grievance_type.grievance = " " }
    it { should_not be_valid }
  end
  
  describe "when grievance is nil" do
    before { @grievance_type.grievance = nil }
    it { should_not be_valid }
  end
  
  describe "when grievance is too long" do
    before { @grievance_type.grievance = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when grievance is a duplicate" do
    before do
      @duplicate = @grievance_type.dup
      @duplicate.grievance.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
end
