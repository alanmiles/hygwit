require 'spec_helper'

describe "JoinerActivityPages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @joiner_activity = @business.joiner_activities.create(action: "Prepare desk")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_joiner_activities_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_joiner_activity_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_joiner_activity_path(@joiner_activity)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the joiner action data" do
      
      describe "with a PUT request" do
        before { put joiner_activity_path(@joiner_activity) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete joiner_activity_path(@joiner_activity) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_joiner_activities_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_joiner_activity_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_joiner_activity_path(@joiner_activity)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the joiner action data" do
      
        describe "with a PUT request" do
          before { put joiner_activity_path(@joiner_activity) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete joiner_activity_path(@joiner_activity) }
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
      
        before { visit business_joiner_activities_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_joiner_activity_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_joiner_activity_path(@joiner_activity)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the joiner action data" do
      
        describe "with a PUT request" do
          before { put joiner_activity_path(@joiner_activity) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete joiner_activity_path(@joiner_activity) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @joiner_activity_2 = @business.joiner_activities.create(action: "Offer accepted") 
        #add employee records - then prevent deletion if already used.
      end
    
      describe "index page" do
      
        before { visit business_joiner_activities_path(@business) }
      
        it { should have_selector('h1', text: 'Joiner Actions') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('.joiner_activity', text: @joiner_activity.action) }
        it { should have_selector('.joiner_activity', text: @joiner_activity_2.action) }
        
        it { should have_selector('.joiner_activity', text: @joiner_activity_2.contract_status) }
        it { should have_selector('.joiner_activity', text: @joiner_activity_2.residence_status) }
        it { should have_selector('.joiner_activity', text: @joiner_activity_2.nationality_status) }
        it { should have_selector('.joiner_activity', text: @joiner_activity_2.mar_status) }
        
        it { should have_link('edit', href: edit_joiner_activity_path(@joiner_activity)) }
        it { should have_link('edit', href: edit_joiner_activity_path(@joiner_activity_2)) }
        it { should have_link('del', href: joiner_activity_path(@joiner_activity)) }
        it { should have_link('Add a joiner action', href: new_business_joiner_activity_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        describe "no delete link for joiner_activities that have already been used" do
          pending "Add when employee records are in place"
          #it { should_not have_link('del', href: joiner_activity_path(@joiner_activity_2)) }
        end
        
        it "should delete joiner_activity (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.joiner_activities, :count).by(-1)
        end
      end
      
      
      describe "new page" do
      
        before { visit new_business_joiner_activity_path(@business) }
      
        it { should have_selector('h1', text: 'New Joiner Action') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#joiner_activity_action") }
        it { should have_selector("#joiner_activity_residence") }
        it { should have_selector('#joiner_activity_created_by', type: 'hidden', value: @user.id) }
        it { should have_selector('#joiner_activity_updated_by', type: 'hidden', value: @user.id) }
        it { should have_link("All joiner actions", href: business_joiner_activities_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new joiner action" do
      
          before { fill_in "Action",  with: "Orientation" }
        
          it "should create a joiner action" do
            expect { click_button "Create" }.to change(@business.joiner_activities, :count).by(1)
            page.should have_selector('h1', text: "Joiner Actions")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Orientation' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Action",  with: "" }
        
          it "should not create a joiner action" do
            expect { click_button "Create" }.not_to change(JoinerActivity, :count)
            page.should have_selector('h1', text: 'New Joiner Action')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_joiner_activity_path(@joiner_activity) }
      
        it { should have_selector('h1', text: 'Edit Joiner Action') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#joiner_activity_action") }
        it { should have_selector('input', value: @joiner_activity.contract) }
        it { should have_selector('input', value: @joiner_activity.residence) }
        it { should have_selector('input', value: @joiner_activity.nationality) }
        it { should have_selector('input', value: @joiner_activity.marital_status) }
        it { should have_link("All joiner actions", href: business_joiner_activities_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the joiner action" do
      
          let(:new_action) { "foobar" }
          before do
            fill_in 'Action', with: new_action
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Joiner Actions') }
          it { should have_selector('div.alert.alert-success') }
          specify { @joiner_activity.reload.action.should == new_action }
          specify { @joiner_activity.reload.updated_by.should == @user.id }
               
        end
      
        describe "joiner action that fails validation" do
      
          let(:new_action) { " " }
          before do
            fill_in 'Action', with: new_action
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Joiner Action') }
          it { should have_content('error') }
          specify { @joiner_activity.reload.action.should == @joiner_activity.action }
        end
      end
    end
  end
end
