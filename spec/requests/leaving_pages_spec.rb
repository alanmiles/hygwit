require 'spec_helper'

describe "LeavingPages" do
  
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @leaving_cat = @business.leaving_cats.create(reason: "Redundancy")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_leaving_cats_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_leaving_cat_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_leaving_cat_path(@leaving_cat)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the leaving_cat data" do
      
      describe "with a PUT request" do
        before { put leaving_cat_path(@leaving_cat) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete leaving_cat_path(@leaving_cat) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_leaving_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_leaving_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_leaving_cat_path(@leaving_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the leaving_cats data" do
      
        describe "with a PUT request" do
          before { put leaving_cat_path(@leaving_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete leaving_cat_path(@leaving_cat) }
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
      
        before { visit business_leaving_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_leaving_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_leaving_cat_path(@leaving_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the leaving_cats data" do
      
        describe "with a PUT request" do
          before { put leaving_cat_path(@leaving_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete leaving_cat_path(@leaving_cat) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @leaving_cat_2 = @business.leaving_cats.create(reason: "Fired") 
        #add employee records - then prevent deletion if already used.
      end
    
      describe "index page" do
      
        before { visit business_leaving_cats_path(@business) }
      
        it { should have_selector('h1', text: 'Leaving Reasons') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('li', text: @leaving_cat.reason) }
        it { should have_selector('li', text: @leaving_cat_2.reason) }
        it { should_not have_selector('li', text: "Full leaving benefits") }
        it { should have_link('edit', href: edit_leaving_cat_path(@leaving_cat)) }
        it { should have_link('edit', href: edit_leaving_cat_path(@leaving_cat_2)) }
        it { should have_link('del', href: leaving_cat_path(@leaving_cat)) }
        it { should have_link('Add a leaving reason', href: new_business_leaving_cat_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        describe "no delete link for leaving_cats that have already been used" do
          pending "Add when employee records are in place"
          #it { should_not have_link('del', href: leaving_cat_path(@leaving_cat_2)) }
        end
        
        it "should delete leaving_cat (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.leaving_cats, :count).by(-1)
        end
      end
      
      
      describe "new page" do
      
        before { visit new_business_leaving_cat_path(@business) }
      
        it { should have_selector('h1', text: 'New Leaving Reason') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#leaving_cat_reason") }
        it { should have_selector("input#leaving_cat_full_benefits") }
        it { should have_link("All leaving reasons", href: business_leaving_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new leaving reason" do
      
          before { fill_in "Reason",  with: "Truancy" }
        
          it "should create a leaving reason" do
            expect { click_button "Create" }.to change(@business.leaving_cats, :count).by(1)
            page.should have_selector('h1', text: "Leaving Reasons")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Truancy' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Reason",  with: "" }
        
          it "should not create a leaving reason" do
            expect { click_button "Create" }.not_to change(LeavingCat, :count)
            page.should have_selector('h1', text: 'New Leaving Reason')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_leaving_cat_path(@leaving_cat) }
      
        it { should have_selector('h1', text: 'Edit Leaving Reason') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#leaving_cat_reason") }
        it { should have_selector("input#leaving_cat_full_benefits") }
        it { should have_link("All leaving reasons", href: business_leaving_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the leaving reason" do
      
          let(:new_reason) { "foobar" }
          before do
            fill_in 'Reason', with: new_reason
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Leaving Reasons') }
          it { should have_selector('div.alert.alert-success') }
          specify { @leaving_cat.reload.reason.should == new_reason }
          specify { @leaving_cat.reload.updated_by.should == @user.id }
               
        end
      
        describe "leaving reason that fails validation" do
      
          let(:new_reason) { " " }
          before do
            fill_in 'Reason', with: new_reason
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Leaving Reason') }
          it { should have_content('error') }
          specify { @leaving_cat.reload.reason.should == @leaving_cat.reason }
        end
      end
    end
  end
end
