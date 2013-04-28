# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  department_id :integer
#  job_title     :string(255)
#  jobfamily_id  :integer
#  positions     :integer          default(1)
#  current       :boolean          default(TRUE)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Job do
  before do
    @country = FactoryGirl.create(:country, created_by: 1, complete: true)
    @jobfamily = FactoryGirl.create(:jobfamily, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, created_by: 1)
    @department = @business.departments.create(department: "Dept B", dept_code: "DPTB")
    @job = @department.jobs.build(job_title: "Executive Secretary", jobfamily_id: @jobfamily.id)
  end
  
  
  subject { @job }
  
  it { should respond_to(:department_id) }
  its(:department) { should == @department }
  it { should respond_to(:job_title) }
  it { should respond_to(:jobfamily_id) }
  it { should respond_to(:positions) }
  it { should respond_to(:current) }
  it { should respond_to(:updated_by) }
  it { should respond_to(:created_by) }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to department_id" do
      expect do
        Job.new(department_id: @department.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when department_id is nil" do
    before { @job.department_id = nil }
    it { should_not be_valid }
  end
  
  describe "when jobfamily_id is nil" do
    before { @job.jobfamily = nil }
    it { should_not be_valid }
  end
  
  describe "when job_title field is blank" do
    before { @job.job_title = " " }
    it { should_not be_valid }
  end
  
  describe "when job_title field is nil" do
    before { @job.job_title = nil }
    it { should_not be_valid }
  end
  
  describe "when job_title field is too long" do
    before { @job.job_title = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when 'positions' is nil" do
    before { @job.positions = nil }
    it { should_not be_valid }
  end
  
  describe "when 'positions' is negative" do
    before { @job.positions = -1 }
    it { should_not be_valid }
  end
  
  describe "when 'positions' is not an integer" do
    before { @job.positions = 3.5 }
    it { should_not be_valid }
  end
  
  describe "when job is a duplicate (for department)" do
    before do
      duplicate = @job.dup
      duplicate.job_title = duplicate.job_title.upcase
      duplicate.save
    end
    it { should_not be_valid }
  end
  
  describe "when job_title is a duplicate but for a different department" do
    before do
      @department_2 = @department.dup
      @department_2.department = "FooBar"
      @department_2.dept_code = "FOO"
      @department_2.save      
      non_dup = @department_2.jobs.create(job_title: "Executive Secretary")
    end
    it { should be_valid }  
  end
end
