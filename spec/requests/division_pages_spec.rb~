require 'spec_helper'

describe "DivisionPages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @division = @business.divisions.create(division: "Sales")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_divisions_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_division_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_division_path(@division)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the divisions data" do
      
      describe "with a PUT request" do
        before { put division_path(@division) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete division_path(@division) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_divisions_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_division_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_division_path(@division)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the divisions data" do
      
        describe "with a PUT request" do
          before { put division_path(@division) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete division_path(@division) }
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
      
        before { visit business_divisions_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_division_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_division_path(@division)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the divisions data" do
      
        describe "with a PUT request" do
          before { put division_path(@division) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete division_path(@division) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @division_2 = @business.divisions.create(division: "Div 2") 
        @division_3 = @business.divisions.create(division: "Div 3", current: false)
        @department = @business.departments.create(department: "Sales", dept_code: "SAL", 
        								division_id: @division_2.id, current: false)
      end
    
      describe "index page" do
      
        before { visit business_divisions_path(@business) }
      
        it { should have_selector('h1', text: 'Divisions') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('.span3', text: @division.division) }
        it { should have_selector('.span3', text: @division_2.division) }
        it { should have_link('edit', href: edit_division_path(@division)) }
        it { should have_link('edit', href: edit_division_path(@division_2)) }
        it { should have_link('del', href: division_path(@division)) }
        it { should have_link('Add a division', href: new_business_division_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
        
        describe "no listing if the division is not current" do
          it { should_not have_selector('.span3', text: @division_3.division) }
        end
        
        describe "no delete link for divisions with a linked department, even if dept not current" do
          it { should_not have_link('del', href: division_path(@division_2)) }
        end
        
        it "should delete division (when delete button is shown)" do
          expect { click_link('del') }.to change(Division, :count).by(-1)
        end
      end
      
      describe "index page with no former divisions" do
      
        before do
          @division_3.toggle!(:current)
          visit business_divisions_path(@business)
        end
        
        it { should_not have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
      end
      
      describe "old divisions index" do
      
        before do
          @division_2.toggle!(:current) 
          visit business_old_divisions_path(@business)
        end
      
        it { should have_selector('h1', text: 'Old Divisions') }
        it { should have_selector('h1', text: @business.name) }
        it { should_not have_selector('.span3', text: @division.division) }
        it { should have_selector('.span3', text: @division_2.division) }
        it { should have_selector('.span3', text: @division_3.division) }
        it { should have_link('edit', href: edit_division_path(@division_3)) }
        it { should have_link('del', href: division_path(@division_3)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('Current divisions', href: business_divisions_path(@business)) }
        
        describe "no delete link for divisions with a linked department, even if dept not current" do
          it { should_not have_link('del', href: division_path(@division_2)) }
        end
        
        it "should delete division (when delete button is shown)" do
          expect { click_link('del') }.to change(Division, :count).by(-1)
        end
      
      end
      
      describe "new page" do
      
        before { visit new_business_division_path(@business) }
      
        it { should have_selector('h1', text: 'New Division') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#division_division") }
        it { should_not have_selector("input#division_current") }
        it { should have_link("All divisions", href: business_divisions_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        it { should have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
      
        describe "creating a new division" do
      
          before { fill_in "Division",  with: "New Division" }
        
          it "should create a division" do
            expect { click_button "Create" }.to change(@business.divisions, :count).by(1)
            page.should have_selector('h1', text: "Divisions")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'New Division' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Division",  with: "" }
        
          it "should not create a Division" do
            expect { click_button "Create" }.not_to change(Division, :count)
            page.should have_selector('h1', text: 'New Division')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "new page with no former divisions" do
      
        before do
          @division_3.toggle!(:current)
          visit new_business_division_path(@business)
        end
        
        it { should_not have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
      
      end
      
      describe "edit page" do
      
        before { visit edit_division_path(@division) }
      
        it { should have_selector('h1', text: 'Edit Division') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#division_division") }
        it { should have_selector("input#division_current") }
        it { should have_link("All divisions", href: business_divisions_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        it { should have_selector(".instruction", text: "This division has no related current departments") }
        it { should_not have_selector(".instruction", text: "This division is not in your current list") }
        it { should have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
      
        describe "editing the division name" do
      
          let(:new_div) { "Manfacturing" }
          before do
            fill_in 'Division', with: new_div
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Divisions') }
          it { should have_selector('div.alert.alert-success') }
          specify { @division.reload.division.should == new_div }
          specify { @division.reload.updated_by.should == @user.id }
               
        end
      
        describe "division name that fails validation" do
      
          let(:new_div) { " " }
          before do
            fill_in 'Division', with: new_div
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Division') }
          it { should have_content('error') }
          specify { @division.reload.division.should == @division.division }
        end
      
        describe "declaring that the division is no longer current" do
        
          before do
            uncheck "division_current"
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Divisions') }
          it { should have_selector('div.alert.alert-success') }
          it { should_not have_selector('.span3', text: @division.division) }
        end
      end
      
      describe "edit page with no former divisions" do
      
        before do
          @division_3.toggle!(:current)  #@division_3 is current
          visit edit_division_path(@division)
        end
        
        it { should_not have_link('View / reinstate old divisions', href: business_old_divisions_path(@business)) }
      
      end
      
      describe "edit page when division has related departments" do
      
        before do
          @department.toggle!(:current) #@division is current
          visit edit_division_path(@division_2)
        end
      
        it { should_not have_selector("input#division_current") }
        it { should_not have_selector(".instruction", text: "This division has no related current departments") }        
      end
      
      describe "edit page when division is not current" do
       
        before do
          visit edit_division_path(@division_3)  #@division_3 is not current
        end
        
        it { should have_selector(".instruction", text: "This division is not in your current list") }
      end
    end
  end
end
 

