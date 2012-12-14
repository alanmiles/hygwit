#Deals with Sectors, Jobfamilies, LeavingReasons, DisciplinaryCategories, GrievanceTypes and Contracts

require 'spec_helper'

describe "AdminPages" do
  
  subject { page }
  
  before do
    @sector = Sector.create(sector: 'Banking', created_by: 1)
    @jobfamily = Jobfamily.create(job_family: 'Sales', created_by: 1)
    @leaving_reason = LeavingReason.create(reason: 'Resigned')
    @disciplinary_cat = DisciplinaryCategory.create(category: "Inappropriate behavior")
    @grievance_type = GrievanceType.create(grievance: "Unfair criticism")
    @contract = Contract.create(contract: "Seconded")
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
      
      describe "when trying to change the sector data" do
      
        describe "with a PUT request" do
          before { put sector_path(@sector) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete sector_path(@sector) }
          specify { response.should redirect_to(root_path) }        
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
      
      describe "when trying to change the jobfamily data" do
      
        describe "with a PUT request" do
          before { put jobfamily_path(@jobfamily) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete jobfamily_path(@jobfamily) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "LeavingReason controller" do
      
      before { visit new_leaving_reason_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit leaving_reasons_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the leaving_reason data" do
      
        describe "with a PUT request" do
          before { put leaving_reason_path(@leaving_reason) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete leaving_reason_path(@leaving_reason) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "DisciplinaryCategory controller" do
      
      before { visit new_disciplinary_category_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit disciplinary_categories_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the disciplinary category data" do
      
        describe "with a PUT request" do
          before { put disciplinary_category_path(@disciplinary_cat) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete disciplinary_category_path(@disciplinary_cat) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "GrievanceTypes controller" do
      
      before { visit new_grievance_type_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit grievance_types_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the grievance_type data" do
      
        describe "with a PUT request" do
          before { put grievance_type_path(@grievance_type) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete grievance_type_path(@grievance_type) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "Contracts controller" do
    
      before { visit new_contract_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit contracts_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the sector data" do
      
        describe "with a PUT request" do
          before { put contract_path(@contract) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete contract_path(@contract) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
  end
  
  describe "when logged in as non-admin" do
  
    before do
      user = FactoryGirl.create(:user, name: "A User", email: "auser@example.com")
      sign_in user
    end
    
    describe "sector controller" do
    
      describe "when trying to access the index" do
        
        before { visit sectors_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_sector_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Sectors#destroy action" do
          before { delete sector_path(@sector) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Sectors#update action" do
        before { put sector_path(@sector) }
        specify { response.should redirect_to(root_path) }
      end
      
    end
    
    describe "jobfamilies controller" do
    
      describe "when trying to access the index" do
        
        before { visit jobfamilies_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_jobfamily_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Jobfamilies#destroy action" do
          before { delete jobfamily_path(@jobfamily) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Jobfamilies#update action" do
        before { put jobfamily_path(@jobfamily) }
        specify { response.should redirect_to(root_path) }
      end
      
    end
    
    describe "LeavingReasons controller" do
    
      describe "when trying to access the index" do
        
        before { visit leaving_reasons_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_leaving_reason_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the LeavingReasons#destroy action" do
          before { delete leaving_reason_path(@leaving_reason) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Nationalities#update action" do
        before { put leaving_reason_path(@leaving_reason) }
        specify { response.should redirect_to(root_path) }
      end
    end
      
    describe "DisciplinaryCategories controller" do
    
      describe "when trying to access the index" do
        
        before { visit disciplinary_categories_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_disciplinary_category_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the DisciplinaryCategories#destroy action" do
          before { delete disciplinary_category_path(@disciplinary_cat) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Nationalities#update action" do
        before { put disciplinary_category_path(@disciplinary_cat) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "GrievanceTypes controller" do
    
      describe "when trying to access the index" do
        
        before { visit grievance_types_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_grievance_type_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the GrievanceTypes#destroy action" do
          before { delete grievance_type_path(@grievance_type) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Nationalities#update action" do
        before { put grievance_type_path(@grievance_type) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "Contracts controller" do
    
      describe "when trying to access the index" do
        
        before { visit contracts_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
      
      describe "when trying to enter a new record" do
      
        before { visit new_contract_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end

      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Contracts#destroy action" do
          before { delete contract_path(@contract) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Nationalities#update action" do
        before { put contract_path(@contract) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
  
  describe "when logged in as admin" do
  
    before do
      @admin = FactoryGirl.create(:admin, name: "Admin Admin", email: "adminadmin@example.com")
      sign_in @admin
    end
    
    describe "sector controller" do
    
      describe "index" do
      
        before do  
          @sector = Sector.create(sector: 'Business', created_by: @admin.id)
          @sector_2 = Sector.create(sector: 'Manufacturing', created_by: 999999)
          @sector_3 = Sector.create(sector: 'Automobile', created_by: 999999)
          visit sectors_path
        end
      
        it { should have_selector('title', text: 'Sectors') }
        it { should have_selector('h1', text: 'Sectors') }
        it { should have_selector('#recent-adds') }
        it { should have_selector('.recent', text: "*") }
        it { should_not have_selector('#recent-add-checks') }
        it { should_not have_selector('#recent-update-checks') }
        it { should_not have_selector('.recent', text: "+") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_sector_path(@sector)) }
          it { should have_link('delete', href: sector_path(@sector)) }
          it { should_not have_link('delete', href: sector_path(@sector_2)) }
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
        it { should_not have_selector('input#sector_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#sector_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#sector_updated_by', type: 'hidden', value: @admin.id) }
    
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
          @sector_3 = Sector.create(sector: 'Insurance', checked: true, created_by: 999999)
          visit edit_sector_path(@sector_3)
        end
    
        it { should have_selector('title', text: 'Edit Sector') }
        it { should have_selector('h1',    text: 'Edit Sector') }
        it { should have_selector('input', value: @sector_3.sector) }
        it { should_not have_selector('input#nationality_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_link('Back', href: sectors_path) }
        it { should have_selector('#sector_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#sector_updated_by', type: 'hidden', value: @admin.id) }
    
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
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Sectors') }
          it { should have_selector('div.alert.alert-success') }
          specify { @sector_3.reload.sector.should == new_sector }
          specify { @sector_3.reload.checked.should == false }
          specify { @sector_3.reload.updated_by.should == @admin.id }
        end
      end 
    end
    
    describe "jobfamilies controller" do
    
      describe "index" do
      
        before do  
          @jobfamily = Jobfamily.create(job_family: 'Banking', created_by: @admin.id)
          @jobfamily_2 = Jobfamily.create(job_family: 'Management', created_by: 999999)
          @jobfamily_3 = Jobfamily.create(job_family: 'Audit', created_by: 999999)
          visit jobfamilies_path
        end
      
        it { should have_selector('title', text: 'Occupations') }
        it { should have_selector('h1', text: 'Occupations') }
        it { should_not have_selector('#recent-adds', text: "needing approval") }
        it { should have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_jobfamily_path(@jobfamily)) }
          it { should have_link('delete', href: jobfamily_path(@jobfamily)) }
          it { should_not have_link('delete', href: jobfamily_path(@jobfamily_2)) }
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
      
        it { should have_selector('title', text: 'New Occupation') }
        it { should have_selector('h1',    text: 'New Occupation') }
        it { should have_link('Back', href: jobfamilies_path) }
        it { should_not have_selector('#jobfamily_checked', type: 'checkbox') }
        it { should_not have_selector('input#jobfamily_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#jobfamily_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#jobfamily_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "creating a new job_family" do
      
          before { fill_in "Occupation",  with: "Merchandizing" }
        
          it "should create a job_family" do
            expect { click_button "Create" }.to change(Jobfamily, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Occupation",  with: "" }
        
          it "should not create a job_family" do
            expect { click_button "Create" }.not_to change(Jobfamily, :count)
            page.should have_selector('h1', text: 'New Occupation')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @jobfamily_3 = Jobfamily.create(job_family: 'Doctor', created_by: 999999)
          visit edit_jobfamily_path(@jobfamily_3)
        end
    
        it { should have_selector('title', text: 'Edit Occupation') }
        it { should have_selector('h1',    text: 'Edit Occupation') }
        it { should have_selector('input', value: @jobfamily_3.job_family) }
        it { should_not have_selector('#jobfamily_checked', type: 'checkbox') }
        it { should have_link('Back', href: jobfamilies_path) }
        it { should have_selector('#jobfamily_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#jobfamily_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "with invalid data" do
          before do
            fill_in 'Occupation', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Occupation') }
          it { should have_content('error') }
          specify { @jobfamily_3.reload.job_family.should == 'Doctor' }
        end
      
        describe "with valid data" do
      
          let(:new_family) { "Medical Staff" }
          before do
            fill_in 'Occupation', with: new_family
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Occupations') }
          it { should have_selector('div.alert.alert-success') }
          specify { @jobfamily_3.reload.job_family.should == new_family }
          specify { @jobfamily_3.reload.checked.should == false }
          specify { @jobfamily_3.reload.updated_by.should == @admin.id }
        end
      end 
    end
    
    describe "LeavingReasons controller" do
    
      describe "index" do
      
        before do  
          @reason = LeavingReason.create(reason: 'Retired', created_by: @admin.id)
          @reason_2 = LeavingReason.create(reason: 'Redundant', full_benefits: true, created_by: 999999)
          @reason_3 = LeavingReason.create(reason: 'Disciplinary', full_benefits: true, created_by: 999999)
          visit leaving_reasons_path
        end
      
        it { should have_selector('title', text: 'Leaving Reasons') }
        it { should have_selector('h1', text: 'Leaving Reasons') }
        it { should have_selector('#recent-adds', text: "in past 7 days") }
        it { should have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_leaving_reason_path(@reason)) }
          it { should have_link('delete', href: leaving_reason_path(@reason)) }
          it { should_not have_link('delete', href: leaving_reason_path(@reason_2)) }
          it { should have_link('Add', href: new_leaving_reason_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'Retired') }
        
          describe "leaving reason already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a leaving reason" do
            expect { click_link('delete') }.to change(LeavingReason, :count).by(-1)
          end
          
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_leaving_reason_path }
      
        it { should have_selector('title', text: 'New Leaving Reason') }
        it { should have_selector('h1',    text: 'New Leaving Reason') }
        it { should have_link('Back', href: leaving_reasons_path) }
        it { should have_selector('#terminating', value: '1') }
        it { should_not have_selector('input#leaving_reason_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#leaving_reason_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#leaving_reason_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "creating a new leaving reason" do
      
          before do
            fill_in "Reason",  with: "Death"
            check "Check if leaver receives full leaving benefits"
          end
        
          it "should create a leaving reason" do
            expect { click_button "Create" }.to change(LeavingReason, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Reason",  with: "" }
        
          it "should not create a leaving reason" do
            expect { click_button "Create" }.not_to change(LeavingReason, :count)
            page.should have_selector('h1', text: 'New Leaving Reason')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @reason_3 = LeavingReason.create(reason: 'Fighting', full_benefits: true, created_by: 999999)
          visit edit_leaving_reason_path(@reason_3)
        end
    
        it { should have_selector('title', text: 'Edit Leaving Reason') }
        it { should have_selector('h1',    text: 'Edit Leaving Reason') }
        it { should have_selector('input', value: @reason_3.reason) }
        it { should have_selector('#terminating', type: 'checkbox') }
        it { should have_link('Back', href: leaving_reasons_path) }
        it { should have_selector('#leaving_reason_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#leaving_reason_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "with invalid data" do
          before do
            fill_in 'Reason', with: " "
            click_button "Save changes"
          end
        
          it { should have_selector('title', text: 'Edit Leaving Reason') }
          it { should have_content('error') }
          specify { @reason_3.reload.reason.should == 'Fighting' }
        end
      
        describe "with valid data" do
      
          let(:new_reason) { "Early retirement" }
          before do
            fill_in 'Reason', with: new_reason
            uncheck 'Check if leaver receives full leaving benefits'
            click_button "Save changes"
          end
      
          it { should have_selector('title', text: 'Leaving Reasons') }
          it { should have_selector('div.alert.alert-success') }
          specify { @reason_3.reload.reason.should == new_reason }
          specify { @reason_3.reload.full_benefits.should == false }
        end
      end 
    end
    
    describe "DisciplinaryCategories controller" do
    
      describe "index" do
      
        before do  
          @dcat = DisciplinaryCategory.create(category: 'Theft', created_by: @admin.id)
          @dcat_2 = DisciplinaryCategory.create(category: 'Disobeying instructions', created_by: 999999)
          @dcat_3 = DisciplinaryCategory.create(category: 'Ignoring health & safety rules', created_by: 999999)
          visit disciplinary_categories_path
        end
      
        it { should have_selector('title', text: 'Disciplinary Categories') }
        it { should have_selector('h1', text: 'Disciplinary Categories') }
        it { should have_selector('#recent-adds', text: "in past 7 days") }
        it { should have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_disciplinary_category_path(@dcat)) }
          it { should have_link('delete', href: disciplinary_category_path(@dcat)) }
          it { should_not have_link('delete', href: disciplinary_category_path(@dcat_2)) }
          it { should have_link('Add', href: new_disciplinary_category_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'Theft') }
        
          describe "disciplinary category already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a disciplinary category" do
            expect { click_link('delete') }.to change(DisciplinaryCategory, :count).by(-1)
          end
          
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_disciplinary_category_path }
      
        it { should have_selector('title', text: 'New Disciplinary Category') }
        it { should have_selector('h1',    text: 'New Disciplinary Category') }
        it { should have_link('Back', href: disciplinary_categories_path) }
        it { should_not have_selector('input#disciplinary_category_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#disciplinary_category_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#disciplinary_category_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "creating a new disciplinary category" do
      
          before do
            fill_in "Category",  with: "Insolence"
          end
        
          it "should create a disciplinary category" do
            expect { click_button "Create" }.to change(DisciplinaryCategory, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Category",  with: "" }
        
          it "should not create a disciplinary category" do
            expect { click_button "Create" }.not_to change(DisciplinaryCategory, :count)
            page.should have_selector('h1', text: 'New Disciplinary Category')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @dcat_3 = DisciplinaryCategory.create(category: 'Persistent lateness', created_by: 999999)
          visit edit_disciplinary_category_path(@dcat_3)
        end
    
        it { should have_selector('title', text: 'Edit Disciplinary Category') }
        it { should have_selector('h1',    text: 'Edit Disciplinary Category') }
        it { should have_selector('input', value: @dcat_3.category) }
        it { should have_link('Back', href: disciplinary_categories_path) }
        it { should have_selector('#disciplinary_category_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#disciplinary_category_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "with invalid data" do
          before do
            fill_in 'Category', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Disciplinary Category') }
          it { should have_content('error') }
          specify { @dcat_3.reload.category.should == 'Persistent lateness' }
        end
      
        describe "with valid data" do
      
          let(:new_cat) { "Persistent absence" }
          before do
            fill_in 'Category', with: new_cat
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Disciplinary Categories') }
          it { should have_selector('div.alert.alert-success') }
          specify { @dcat_3.reload.category.should == new_cat }
        end
      end 
    end
    
    describe "GrievanceTypes controller" do
    
      describe "index" do
      
        before do  
          @gtype = GrievanceType.create(grievance: 'Violence', created_by: @admin.id)
          @gtype_2 = GrievanceType.create(grievance: 'Sexual harrassment', created_by: 999999)
          @gtype_3 = GrievanceType.create(grievance: 'No career advancement', created_by: 999999)
          visit grievance_types_path
        end
      
        it { should have_selector('title', text: 'Grievance Types') }
        it { should have_selector('h1', text: 'Grievance Types') }
        it { should have_selector('#recent-adds', text: "in past 7 days") }
        it { should have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_grievance_type_path(@gtype)) }
          it { should have_link('delete', href: grievance_type_path(@gtype)) }
          it { should_not have_link('delete', href: grievance_type_path(@gtype_2)) }
          it { should have_link('Add', href: new_grievance_type_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'Violence') }
        
          describe "grievance type already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a grievance type" do
            expect { click_link('delete') }.to change(GrievanceType, :count).by(-1)
          end
          
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_grievance_type_path }
      
        it { should have_selector('title', text: 'New Grievance Type') }
        it { should have_selector('h1',    text: 'New Grievance Type') }
        it { should have_link('Back', href: grievance_types_path) }
        it { should_not have_selector('input#grievance_type_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#grievance_type_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#grievance_type_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "creating a new grievance type" do
      
          before do
            fill_in "Grievance",  with: "Unfair appraisal"
          end
        
          it "should create a grievance type" do
            expect { click_button "Create" }.to change(GrievanceType, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Grievance",  with: "" }
        
          it "should not create a grievance type" do
            expect { click_button "Create" }.not_to change(GrievanceType, :count)
            page.should have_selector('h1', text: 'New Grievance Type')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @gtype_3 = GrievanceType.create(grievance: 'Salary miscalculation', created_by: 999999)
          visit edit_grievance_type_path(@gtype_3)
        end
    
        it { should have_selector('title', text: 'Edit Grievance Type') }
        it { should have_selector('h1',    text: 'Edit Grievance Type') }
        it { should have_selector('input', value: @gtype_3.grievance) }
        it { should have_link('Back', href: grievance_types_path) }
        it { should have_selector('#grievance_type_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#grievance_type_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "with invalid data" do
          before do
            fill_in 'Grievance', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Grievance Type') }
          it { should have_content('error') }
          specify { @gtype_3.reload.grievance.should == 'Salary miscalculation' }
        end
      
        describe "with valid data" do
      
          let(:new_grievance) { "Favortism" }
          before do
            fill_in 'Grievance', with: new_grievance
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Grievance Types') }
          it { should have_selector('div.alert.alert-success') }
          specify { @gtype_3.reload.grievance.should == new_grievance }
        end
      end 
    end
    
    describe "Contracts controller" do
    
      describe "index" do
      
        before do  
          @contract_2 = Contract.create(contract: 'Volunteer', created_by: @admin.id)
          @contract_3 = Contract.create(contract: 'Full-time', created_by: 999999)
          visit contracts_path
        end
      
        it { should have_selector('title', text: 'Contract Types') }
        it { should have_selector('h1', text: 'Contract Types') }
        it { should have_selector('#recent-adds', text: "in past 7 days") }
        it { should have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_contract_path(@contract)) }
          it { should have_link('delete', href: contract_path(@contract_2)) }
          it { should_not have_link('delete', href: contract_path(@contract_3)) }
          it { should have_link('Add', href: new_contract_path) }
          it { should have_selector('ul.itemlist li:nth-child(3)', text: 'Volunteer') }
        
          describe "contract already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a contract" do
            expect { click_link('delete') }.to change(Contract, :count).by(-1)
          end
          
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_contract_path }
      
        it { should have_selector('title', text: 'New Contract') }
        it { should have_selector('h1',    text: 'New Contract') }
        it { should have_link('Back', href: contracts_path) }
        it { should_not have_selector('input#contract_checked') }
        it { should_not have_selector('#update-date', text: "Added") }
        it { should have_selector('#contract_created_by', type: 'hidden', value: @admin.id) }
        it { should have_selector('#contract_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "creating a new contract" do
      
          before do
            fill_in "Contract",  with: "Temporary"
          end
        
          it "should create a contract" do
            expect { click_button "Create" }.to change(Contract, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Contract",  with: "" }
        
          it "should not create a contract" do
            expect { click_button "Create" }.not_to change(Contract, :count)
            page.should have_selector('h1', text: 'New Contract')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @contract_3 = Contract.create(contract: 'Intern', created_by: 999999)
          visit edit_contract_path(@contract_3)
        end
    
        it { should have_selector('title', text: 'Edit Contract') }
        it { should have_selector('h1',    text: 'Edit Contract') }
        it { should have_selector('input', value: @contract_3.contract) }
        it { should have_link('Back', href: contracts_path) }
        it { should have_selector('#contract_created_by', type: 'hidden', value: 999999) }
        it { should have_selector('#contract_updated_by', type: 'hidden', value: @admin.id) }
    
        describe "with invalid data" do
          before do
            fill_in 'Contract', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Contract') }
          it { should have_content('error') }
          specify { @contract_3.reload.contract.should == 'Intern' }
        end
      
        describe "with valid data" do
      
          let(:new_contract) { "Consultant" }
          before do
            fill_in 'Contract', with: new_contract
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Contract Types') }
          it { should have_selector('div.alert.alert-success') }
          specify { @contract_3.reload.contract.should == new_contract }
        end
      end 
    end
  end
  
  describe "when logged in as superuser" do
    
    before do
      @superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
      sign_in @superuser 
    end
    
    describe "sectors controller" do
    
      describe "index" do
      
        before do  
          @sector = Sector.create(sector: 'Business', created_by: @superuser.id, checked: true)
          @sector_2 = Sector.create(sector: 'Manufacturing', created_by: 999999, checked: true)
          @sector_3 = Sector.create(sector: 'Automobile', created_by: 999999, checked: true)
          visit sectors_path
        end
      
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") }  #all records already checked
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: sector_path(@sector)) }
        it { should have_link('delete', href: sector_path(@sector_2)) }
      
        describe "entering a new sector" do
        
          before { visit new_sector_path }
          it { should have_selector('input#sector_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Sector", with: "Foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(Sector, :count) 
              page.should have_selector('h1', text: 'Sectors')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @sector.toggle!(:checked)
            visit edit_sector_path(@sector)
          end
          
          it { should have_selector('input#sector_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit sectors_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the code" do
        
            before do
              fill_in "Sector", with: "Bizness"
              click_button "Save change"
            end
          
            specify { @sector.reload.checked == true }
            specify { @sector.reload.updated_by != @superuser.id }
          end
        end
      end
    end
    
    describe "jobfamilies controller" do
    
      describe "index" do
      
        before do  
          @jobfamily = Jobfamily.create(job_family: 'Banking', created_by: @superuser.id, checked: true)
          @jobfamily_2 = Jobfamily.create(job_family: 'Management', created_by: 999999, checked: true)
          @jobfamily_3 = Jobfamily.create(job_family: 'Audit', created_by: 999999, checked: true)
          visit jobfamilies_path
        end
        
        it { should_not have_selector('#recent-adds') } 
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") } 
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: jobfamily_path(@jobfamily)) }
        it { should have_link('delete', href: jobfamily_path(@jobfamily_2)) }
      
        describe "entering a new occupation" do
        
          before { visit new_jobfamily_path }
          it { should have_selector('input#jobfamily_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Occupation", with: "Foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(Jobfamily, :count) 
              page.should have_selector('h1', text: 'Occupations')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @jobfamily.toggle!(:checked)
            visit edit_jobfamily_path(@jobfamily)
          end
          
          it { should have_selector('input#jobfamily_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit jobfamilies_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the code" do
        
            before do
              fill_in "Occupation", with: "Family"
              click_button "Save change"
            end
          
            specify { @jobfamily.reload.checked == true }
            specify { @jobfamily.reload.updated_by != @superuser.id }
          end
        end
        
      end
    end
    
    describe "LeavingReasons controller" do
    
      describe "index" do
      
        before do  
          @reason = LeavingReason.create(reason: 'Retired', created_by: @superuser.id, checked: true)
          @reason_2 = LeavingReason.create(reason: 'Redundant', full_benefits: true, created_by: 999999, checked: true)
          @reason_3 = LeavingReason.create(reason: 'Disciplinary', full_benefits: true, created_by: 999999, checked: true)
          visit leaving_reasons_path
        end
      
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") }  #all records already checked
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: leaving_reason_path(@reason)) }
        it { should have_link('delete', href: leaving_reason_path(@reason_2)) }
      
        describe "entering a new leaving reason" do
        
          before { visit new_leaving_reason_path }
          it { should have_selector('input#leaving_reason_checked', value: 1) }
          it { should have_selector('input#leaving_reason_full_benefits', type: 'checkbox') }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Reason", with: "If foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(LeavingReason, :count) 
              page.should have_selector('h1', text: 'Leaving Reasons')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @reason.toggle!(:checked)
            visit edit_leaving_reason_path(@reason)
          end
          
          it { should have_selector('input#leaving_reason_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit leaving_reasons_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the reason" do
        
            before do
              fill_in "Reason", with: "Foobar"
              click_button "Save change"
            end
          
            specify { @reason.reload.checked == true }
            specify { @reason.reload.updated_by != @superuser.id }
          end
        end
      end
    end
    
    describe "DisciplinaryCategories controller" do
    
      describe "index" do
      
        before do  
          @dcat = DisciplinaryCategory.create(category: 'Theft', created_by: @superuser.id, checked: true)
          @dcat_2 = DisciplinaryCategory.create(category: 'Disobeying instructions', created_by: 999999, checked: true)
          @dcat_3 = DisciplinaryCategory.create(category: 'Ignoring health & safety rules', created_by: 999999, checked: true)
          visit disciplinary_categories_path
        end
      
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") }  #all records already checked
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: disciplinary_category_path(@dcat)) }
        it { should have_link('delete', href: disciplinary_category_path(@dcat_2)) }
      
        describe "entering a new sector" do
        
          before { visit new_disciplinary_category_path }
          it { should have_selector('input#disciplinary_category_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Category", with: "Foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(DisciplinaryCategory, :count) 
              page.should have_selector('h1', text: 'Disciplinary Categories')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @dcat.toggle!(:checked)
            visit edit_disciplinary_category_path(@dcat)
          end
          
          it { should have_selector('input#disciplinary_category_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit disciplinary_categories_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the category" do
        
            before do
              fill_in "Category", with: "foobar"
              click_button "Save change"
            end
          
            specify { @dcat.reload.checked == true }
            specify { @dcat.reload.updated_by != @superuser.id }
          end
        end
        
      end
    end
    
    describe "GrievanceTypes controller" do
    
      describe "index" do
      
        before do  
          @gtype = GrievanceType.create(grievance: 'Violence', created_by: @superuser.id, checked: true)
          @gtype_2 = GrievanceType.create(grievance: 'Sexual harrassment', created_by: 999999, checked: true)
          @gtype_3 = GrievanceType.create(grievance: 'No career advancement', created_by: 999999, checked: true)
          visit grievance_types_path
        end
        
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") }  #all records already checked
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: grievance_type_path(@gtype)) }
        it { should have_link('delete', href: grievance_type_path(@gtype_2)) }
      
        describe "entering a new grievance type" do
        
          before { visit new_grievance_type_path }
          it { should have_selector('input#grievance_type_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Grievance", with: "Foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(GrievanceType, :count) 
              page.should have_selector('h1', text: 'Grievance Types')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @gtype.toggle!(:checked)
            visit edit_grievance_type_path(@gtype)
          end
          
          it { should have_selector('input#grievance_type_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit grievance_types_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the grievance" do
        
            before do
              fill_in "Grievance", with: "foobar"
              click_button "Save change"
            end
          
            specify { @gtype.reload.checked == true }
            specify { @gtype.reload.updated_by != @superuser.id }
          end
        end
      end
    end
    
    describe "Contracts controller" do
    
      describe "index" do
      
        before do  
          @contract_2 = Contract.create(contract: 'Volunteer', created_by: @superuser.id, checked: true)
          @contract_3 = Contract.create(contract: 'Full-time', created_by: 999999, checked: true)
          visit contracts_path
        end
      
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('#recent-updates') }
        it { should have_selector('#recent-add-checks') }
        it { should have_selector('#recent-update-checks') }
        it { should have_selector('.recent', text: "+") }  #all records already checked
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('delete', href: contract_path(@contract_2)) }
        it { should have_link('delete', href: contract_path(@contract_3)) }
      
        describe "entering a new contract" do
        
          before { visit new_contract_path }
          it { should have_selector('input#contract_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Contract", with: "Foobar"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(Contract, :count).by(1) 
              page.should have_selector('h1', text: 'Contract Types')
              page.should have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @contract_2.toggle!(:checked)
            visit edit_contract_path(@contract_2)
          end
          
          it { should have_selector('input#contract_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit contracts_path }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the contract_type" do
        
            before do
              fill_in "Contract", with: "Barbuzz"
              click_button "Save change"
            end
          
            specify { @contract_2.reload.checked == true }
            specify { @contract_2.reload.updated_by != @superuser.id }
          end
        end
      end
    end
  end
end
