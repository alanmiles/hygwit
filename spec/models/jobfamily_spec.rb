# == Schema Information
#
# Table name: jobfamilies
#
#  id         :integer          not null, primary key
#  job_family :string(255)
#  approved   :boolean          default(FALSE)
#  created_by :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  checked    :boolean          default(FALSE)
#  updated_by :integer          default(1)
#

require 'spec_helper'

describe Jobfamily do
  
  before do
    @jobfamily = Jobfamily.new(job_family: 'Sales', created_by: 1)
  end
  
  subject { @jobfamily }

  it { should respond_to(:job_family) }
  it { should respond_to(:approved) }
  it { should respond_to(:created_by) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:checked) }
  
  it { should be_valid }
  
  describe "when job_family is not present" do
    before { @jobfamily.job_family = " " }
    it { should_not be_valid }
  end
  
  describe "when job_family is nil" do
    before { @jobfamily.job_family = nil }
    it { should_not be_valid }
  end
  
  describe "when job_family is too long" do
    before { @jobfamily.job_family = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when job_family is a duplicate" do
    before do
      @duplicate = @jobfamily.dup
      @duplicate.job_family.upcase
      @duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when 'created_by' is missing" do
    before { @jobfamily.created_by = nil }
    it { should_not be_valid }
  end
end
