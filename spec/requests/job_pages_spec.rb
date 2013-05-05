require 'spec_helper'

describe "JobPages" do
  
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @jobfamily = FactoryGirl.create(:jobfamily, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @division = @business.divisions.create(division: "Sales")
    @department = @business.departments.create(department: "Dept One", dept_code: "ONE", division_id: @division.id)
    @rank_cat = @business.rank_cats.create(rank: "Senior")
    @job = @business.jobs.create(job_title: "Job 1", department_id: @department.id, jobfamily_id: @jobfamily.id,
    										rank_cat_id: @rank_cat.id)
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_jobs_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_job_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_job_path(@job)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the Job data" do
      
      describe "with a PUT request" do
        before { put job_path(@job) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete job_path(@job) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_jobs_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_job_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_job_path(@job)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the Job data" do
      
        describe "with a PUT request" do
          before { put job_path(@job) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete job_path(@job) }
          specify { response.should redirect_to @user }        
        end
      end
    end
  
    describe "business admin, but without access to Settings" do
     
      before do
        @business_2 = FactoryGirl.create(:business, name: "Biz 2", country_id: @country.id, sector_id: 
        									@sector.id, created_by: @user.id)    
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business_2.id, user_id: @user.id, created_by: 1)
      end
      
      describe "index page" do
      
        before { visit business_jobs_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_job_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_job_path(@job)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the Job data" do
      
        describe "with a PUT request" do
          before { put job_path(@job) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete job_path(@job) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @old_job = @business.jobs.create(job_title: "Old Job", department_id: @department.id, jobfamily_id: @jobfamily.id,
    										rank_cat_id: @rank_cat.id, current: false)							
      end
    
      describe "index page" do
      
        before { visit business_jobs_path(@business) }
      
        it { should have_selector('h1', text: 'Jobs') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('.span1', text: @job.department.dept_code) }
        it { should have_selector('.span2', text: @job.job_title) }
        it { should have_selector('.span2', text: @job.jobfamily.job_family) }
        it { should have_selector('.span2', text: @job.rank_cat.rank) }
        it { should have_link('edit', href: edit_job_path(@job)) }
        it { should have_link('del', href: job_path(@job)) }
        it { should have_link('Add a job', href: new_business_job_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
        it { should_not have_selector('.standout', text: "You must enter at least one department") }
        
        describe "no listing if the job is not current" do
          it { should_not have_selector('.span2', text: @old_job.job_title) }
        end
        
        describe "no delete link for jobs with a linked employee" do
          pending "IMPORTANT CHECK WHEN EMPLOYEE MODEL ADDED"
        end
        
        it "should delete job (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.jobs, :count).by(-1)
        end
      end
      
      describe "index page with no former jobs" do
      
        before do
          @old_job.toggle!(:current)
          visit business_jobs_path(@business)
        end
        
        it { should_not have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
      end
      
      describe "old jobs index" do
      
        before do
          #ADD EMPLOYEE - NOT CURRENT EXAMPLE
          
          visit business_old_jobs_path(@business)
        end
      
        it { should have_selector('h1', text: 'Old Jobs') }
        it { should have_selector('h1', text: @business.name) }
        it { should_not have_selector('.span2', text: @job.job_title) }
        it { should have_selector('.span2', text: @old_job.job_title) }
        it { should have_selector('.span1', text: @old_job.department.dept_code) }
        it { should have_selector('.span2', text: @old_job.jobfamily.job_family) }
        it { should have_selector('.span2', text: @old_job.rank_cat.rank) }
        it { should have_link('edit', href: edit_job_path(@old_job)) }
        it { should have_link('del', href: job_path(@old_job)) }             #check this is created without linked employee
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('Current jobs', href: business_jobs_path(@business)) }
        
        describe "no delete link for jobs with a linked employee, even if employee not current" do
          pending "IMPORTANT CHECK"
        end
        
        it "should delete job (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.jobs, :count).by(-1)
        end
      
      end
      
      describe "new page" do
      
        before { visit new_business_job_path(@business) }
      
        it { should have_selector('h1', text: 'New Job') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#job_job_title") }
        it { should have_selector("select#job_department_id") }
        it { should have_selector("select#job_jobfamily_id") }
        it { should have_selector("select#job_rank_cat_id") }
        it { should_not have_selector("input#job_current") }
        it { should have_selector("input#job_positions") }
        it { should have_link("All current jobs", href: business_jobs_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        it { should have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
      
        describe "creating a new job" do
      
          before do
            fill_in "Job title",  with: "Another Job"
            select "#{@department.department}",  from: "job_department_id"
            select "#{@jobfamily.job_family}",  from: "job_jobfamily_id"
            select "#{@rank_cat.rank}",  from: "job_rank_cat_id"
          end
        
          it "should create a job" do
            expect { click_button "Create" }.to change(@business.jobs, :count).by(1)
            page.should have_selector('h1', text: "Jobs")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Another Job' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Job title",  with: "" }
        
          it "should not create a Job" do
            expect { click_button "Create" }.not_to change(Job, :count)
            page.should have_selector('h1', text: 'New Job')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "new page with no former jobs" do
      
        before do
          @old_job.toggle!(:current)
          visit new_business_job_path(@business)
        end
        
        it { should_not have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
      
      end
      
      describe "edit page" do
      
        before { visit edit_job_path(@job) }
      
        it { should have_selector('h1', text: 'Edit Job') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#job_job_title") }
        it { should have_selector("select#job_department_id") }
        it { should have_selector("select#job_jobfamily_id") }
        it { should have_selector("select#job_rank_cat_id") }
        it { should have_selector("input#job_current") }
        it { should have_selector("input#job_positions") }
        it { should have_link("All current jobs", href: business_jobs_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        pending "check as below to see whether any current employees"
        #it { should have_selector(".instruction", text: "This job has no related current employees") }
        it { should_not have_selector(".instruction", text: "This job is not in your current list") }
        it { should have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
      
        describe "editing the job name" do
      
          let(:new_job) { "Renamed Job" }
          before do
            fill_in 'Job title', with: new_job
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Jobs') }
          it { should have_selector('div.alert.alert-success') }
          specify { @job.reload.job_title.should == new_job }
          specify { @job.reload.updated_by.should == @user.id }
               
        end
      
        describe "job name that fails validation" do
      
          let(:new_job) { " " }
          before do
            fill_in 'Job title', with: new_job
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Job') }
          it { should have_content('error') }
          specify { @job.reload.job_title.should == @job.job_title }
        end
      
        describe "declaring that the job is no longer current" do
        
          before do
            uncheck "job_current"
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Jobs') }
          it { should have_selector('div.alert.alert-success') }
          it { should_not have_selector('.span2', text: @job.job_title) }
        end
      end
      
      describe "edit page with no former jobs" do
      
        before do
          @old_job.toggle!(:current)  #@old job becomes current
          visit edit_job_path(@job)
        end
        
        it { should_not have_link('View / reinstate old jobs', href: business_old_jobs_path(@business)) }
      
      end
      
      describe "edit page when job has related employees" do
      
        pending      
      end
      
      describe "edit page when job has related employees, but they're not current" do
      
        pending
      end
      
      describe "edit page when job is not current" do
       
        before do
          visit edit_job_path(@old_job)
        end
        
        it { should have_selector("input#job_current") }
        it { should have_selector(".instruction", text: "This job is not in your current list") }
        it { should_not have_selector(".standout", text: "Was '#{@old_job.department.department}', but this is not current") }
      end
      
      describe "edit page when neither job or it's department is current" do
      
        before do
          @department.toggle!(:current)
          visit edit_job_path(@old_job)
        end
        
        it { should have_selector(".standout", text: "Was '#{@old_job.department.department}', but this is not current") }
      end
    end
    
    describe "business admin, with access to Settings, but no departments set" do
    
      before do
        @business_2 = FactoryGirl.create(:business, name: "Biz 2", country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
        @bizadmin_2 = FactoryGirl.create(:business_admin, business_id: @business_2.id, user_id: @user.id, created_by: 1)
      end
    
      describe "index page" do
      
        before { visit business_jobs_path(@business_2) }
      
        it { should have_selector('h1', text: 'Jobs') }
        it { should_not have_link('Add a job', href: new_business_job_path(@business_2)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business_2)) }
        it { should have_selector('.standout', text: "You must enter at least one department") }
      end
    end
  end
end
