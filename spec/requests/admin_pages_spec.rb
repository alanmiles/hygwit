require 'spec_helper'

describe "AdminPages" do
  
  subject { page }
  
  before do
    @sector = Sector.create(sector: 'Banking', created_by: 1)
    @jobfamily = Jobfamily.create(job_family: 'Sales', created_by: 1)
  end
  
  describe "when not logged in" do
    
    describe "sector controller" do
    
      before { visit new_sector_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit sectors_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
    end
    
    describe "jobfamily controller" do
    
      before { visit new_jobfamily_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit jobfamilies_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
    end
  end
  
  describe "when logged in as non-admin" do
  
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    
    describe "sector controller" do
    
      describe "when trying to access the index" do
        
        before { visit sectors_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
      
      describe "adding a new sector successfully" do
        pending("this should be fine but should be unapproved")
        pending("no return to list button")
      end
      
      describe "editing a sector" do
        pending("this should be possible only for non-approved entries added by the user")
        pending("no return to list button")
      end
      
      describe "deleting a sector" do
        pending("this should be possible only for non-approved entries added by the user")
      end
      
    end
    
    describe "jobfamily controller" do
    
      describe "when trying to access the index" do
        
        before { visit jobfamilies_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
      
      describe "adding a new jobfamily successfully" do
        pending("this should be fine but should be unapproved")
        pending("no return to list button")
      end
      
      describe "editing a job_family" do
        pending("this should be possible only for non-approved entries added by the user")
        pending("no return to list button")
      end
      
      describe "deleting a job_family" do
        pending("this should be possible only for non-approved entries added by the user")
      end
      
    end
  end
  
  describe "when logged in as admin" do
  
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    
    describe "sector controller" do
    
      describe "index" do
      
        before do  
          @sector = Sector.create(sector: 'Business', created_by: 1)
          @sector_2 = Sector.create(sector: 'Manufacturing', created_by: 1)
          @sector_3 = Sector.create(sector: 'Automobile', created_by: 1)
          visit sectors_path
        end
      
        it { should have_selector('title', text: 'Sectors') }
        it { should have_selector('h1', text: 'Sectors') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_sector_path(@sector)) }
          it { should have_link('delete', href: sector_path(@sector)) }
          it { should have_link('Add', href: new_sector_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'Manufacturing') }
        
          describe "sector already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a sector" do
            expect { click_link('delete') }.to change(Sector, :count).by(-1)
          end
          
          describe "when > 10 sectors" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_sector_path }
      
        it { should have_selector('title', text: 'New Sector') }
        it { should have_selector('h1',    text: 'New Sector') }
        it { should have_link('Back', href: sectors_path) }
        it { should have_selector('#approving', value: '1', input_checked: 'checked') }
    
        describe "creating a new sector" do
      
          before { fill_in "Sector",  with: "Hospitality" }
        
          it "should create a sector" do
            expect { click_button "Create" }.to change(Sector, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Sector",  with: "" }
        
          it "should not create a sector" do
            expect { click_button "Create" }.not_to change(Sector, :count)
            page.should have_selector('h1', text: 'New Sector')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @sector_3 = Sector.create(sector: 'Insurance', created_by: 1)
          visit edit_sector_path(@sector_3)
        end
    
        it { should have_selector('title', text: 'Edit Sector') }
        it { should have_selector('h1',    text: 'Edit Sector') }
        it { should have_selector('input', value: @sector_3.sector) }
        it { should have_selector('#approving', type: 'checkbox') }
        it { should have_link('Back', href: sectors_path) }
    
        describe "with invalid data" do
          before do
            fill_in 'Sector', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Sector') }
          it { should have_content('error') }
          specify { @sector_3.reload.sector.should == 'Insurance' }
        end
      
        describe "with valid data" do
      
          let(:new_sector) { "Food" }
          before do
            fill_in 'Sector', with: new_sector
            check 'Approved'
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Sectors') }
          it { should have_selector('div.alert.alert-success') }
          specify { @sector_3.reload.sector.should == new_sector }
          specify { @sector_3.reload.approved.should == true }
        end
      end 
    end
    
    describe "jobfamilies controller" do
    
      describe "index" do
      
        before do  
          @jobfamily = Jobfamily.create(job_family: 'Banking', created_by: 1)
          @jobfamily_2 = Jobfamily.create(job_family: 'Management', created_by: 1)
          @jobfamily_3 = Jobfamily.create(job_family: 'Audit', created_by: 1)
          visit jobfamilies_path
        end
      
        it { should have_selector('title', text: 'Job Families') }
        it { should have_selector('h1', text: 'Job Families') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_jobfamily_path(@jobfamily)) }
          it { should have_link('delete', href: jobfamily_path(@jobfamily)) }
          it { should have_link('Add', href: new_jobfamily_path) }
          it { should have_selector('ul.itemlist li:nth-child(3)', text: 'Management') }
        
          describe "job_family already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a job_family" do
            expect { click_link('delete') }.to change(Jobfamily, :count).by(-1)
          end
          
          describe "when > 10 Job Families" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_jobfamily_path }
      
        it { should have_selector('title', text: 'New Job Family') }
        it { should have_selector('h1',    text: 'New Job Family') }
        it { should have_link('Back', href: jobfamilies_path) }
        it { should have_selector('#approving', value: '1', input_checked: 'checked') }
    
        describe "creating a new job_family" do
      
          before { fill_in "Job family",  with: "Merchandizing" }
        
          it "should create a job_family" do
            expect { click_button "Create" }.to change(Jobfamily, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Job family",  with: "" }
        
          it "should not create a job_family" do
            expect { click_button "Create" }.not_to change(Jobfamily, :count)
            page.should have_selector('h1', text: 'New Job Family')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @jobfamily_3 = Jobfamily.create(job_family: 'Doctor', created_by: 1)
          visit edit_jobfamily_path(@jobfamily_3)
        end
    
        it { should have_selector('title', text: 'Edit Job Family') }
        it { should have_selector('h1',    text: 'Edit Job Family') }
        it { should have_selector('input', value: @jobfamily_3.job_family) }
        it { should have_selector('#approving', type: 'checkbox') }
        it { should have_link('Back', href: jobfamilies_path) }
    
        describe "with invalid data" do
          before do
            fill_in 'Job family', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Job Family') }
          it { should have_content('error') }
          specify { @jobfamily_3.reload.job_family.should == 'Doctor' }
        end
      
        describe "with valid data" do
      
          let(:new_family) { "Medical Staff" }
          before do
            fill_in 'Job family', with: new_family
            check 'Approved'
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Job Families') }
          it { should have_selector('div.alert.alert-success') }
          specify { @jobfamily_3.reload.job_family.should == new_family }
          specify { @jobfamily_3.reload.approved.should == true }
        end
      end 
    end
  end
end
