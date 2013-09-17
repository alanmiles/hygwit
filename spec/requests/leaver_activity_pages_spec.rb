require 'spec_helper'

describe "LeaverActivityPages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @leaver_activity = @business.leaver_activities.create(action: "Interview leaver")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_leaver_activities_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_leaver_activity_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_leaver_activity_path(@leaver_activity)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the leaver action data" do
      
      describe "with a PUT request" do
        before { put leaver_activity_path(@leaver_activity) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete leaver_activity_path(@leaver_activity) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_leaver_activities_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_leaver_activity_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_leaver_activity_path(@leaver_activity)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the leaver action data" do
      
        describe "with a PUT request" do
          before { put leaver_activity_path(@leaver_activity) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete leaver_activity_path(@leaver_activity) }
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
      
        before { visit business_leaver_activities_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_leaver_activity_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_leaver_activity_path(@leaver_activity)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the leaver action data" do
      
        describe "with a PUT request" do
          before { put leaver_activity_path(@leaver_activity) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete leaver_activity_path(@leaver_activity) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @leaver_activity_2 = @business.leaver_activities.create(action: "Prepare settlement") 
        #add employee records - then prevent deletion if already used.
      end
    
      describe "index page" do
      
        before { visit business_leaver_activities_path(@business) }
      
        it { should have_selector('h1', text: 'Leaver Actions') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('.leaver_activity', text: @leaver_activity.action) }
        it { should have_selector('.leaver_activity', text: @leaver_activity_2.action) }
        
        it { should have_selector('.leaver_activity', text: @leaver_activity_2.contract_status) }
        it { should have_selector('.leaver_activity', text: @leaver_activity_2.residence_status) }
        it { should have_selector('.leaver_activity', text: @leaver_activity_2.nationality_status) }
        it { should have_selector('.leaver_activity', text: @leaver_activity_2.mar_status) }
        
        it { should have_link('edit', href: edit_leaver_activity_path(@leaver_activity)) }
        it { should have_link('edit', href: edit_leaver_activity_path(@leaver_activity_2)) }
        it { should have_link('del', href: leaver_activity_path(@leaver_activity)) }
        it { should have_link('Add a leaver action', href: new_business_leaver_activity_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        describe "no delete link for leaver_activities that have already been used" do
          pending "Add when employee records are in place"
          #it { should_not have_link('del', href: leaver_activity_path(@leaver_activity_2)) }
        end
        
        it "should delete leaver_activity (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.leaver_activities, :count).by(-1)
        end
      end
      
      
      describe "new page" do
      
        before { visit new_business_leaver_activity_path(@business) }
      
        it { should have_selector('h1', text: 'New Leaver Action') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#leaver_activity_action") }
        it { should have_selector("#leaver_activity_residence") }
        it { should have_selector('#leaver_activity_created_by', type: 'hidden', value: @user.id) }
        it { should have_selector('#leaver_activity_updated_by', type: 'hidden', value: @user.id) }
        it { should have_link("All leaver actions", href: business_leaver_activities_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new leaver action" do
      
          before { fill_in "Action",  with: "Collect company property" }
        
          it "should create a leaver action" do
            expect { click_button "Create" }.to change(@business.leaver_activities, :count).by(1)
            page.should have_selector('h1', text: "Leaver Actions")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Collect company property' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Action",  with: "" }
        
          it "should not create a leaver action" do
            expect { click_button "Create" }.not_to change(LeaverActivity, :count)
            page.should have_selector('h1', text: 'New Leaver Action')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_leaver_activity_path(@leaver_activity) }
      
        it { should have_selector('h1', text: 'Edit Leaver Action') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#leaver_activity_action") }
        it { should have_selector('input', value: @leaver_activity.contract) }
        it { should have_selector('input', value: @leaver_activity.residence) }
        it { should have_selector('input', value: @leaver_activity.nationality) }
        it { should have_selector('input', value: @leaver_activity.marital_status) }
        it { should have_link("All leaver actions", href: business_leaver_activities_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the leaver action" do
      
          let(:new_action) { "foobar" }
          before do
            fill_in 'Action', with: new_action
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Leaver Actions') }
          it { should have_selector('div.alert.alert-success') }
          specify { @leaver_activity.reload.action.should == new_action }
          specify { @leaver_activity.reload.updated_by.should == @user.id }
               
        end
      
        describe "leaver action that fails validation" do
      
          let(:new_action) { " " }
          before do
            fill_in 'Action', with: new_action
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Leaver Action') }
          it { should have_content('error') }
          specify { @leaver_activity.reload.action.should == @leaver_activity.action }
        end
      end
    end
  end
end
