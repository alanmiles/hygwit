require 'spec_helper'

describe "BizabsencePages" do
  
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @absence_cat = @business.absence_cats.create(absence_code: "XX", maximum_days_year: 5, 
    											documentation_required: false, notes: "Another absence")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_absence_cats_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_absence_cat_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_absence_cat_path(@absence_cat)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the AbsenceCat data" do
      
      describe "with a PUT request" do
        before { put absence_cat_path(@absence_cat) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete absence_cat_path(@absence_cat) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_absence_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_absence_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_absence_cat_path(@absence_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the AbsenceCat data" do
      
        describe "with a PUT request" do
          before { put absence_cat_path(@absence_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete absence_cat_path(@absence_cat) }
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
      
        before { visit business_absence_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_absence_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_absence_cat_path(@absence_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the AbsenceCat data" do
      
        describe "with a PUT request" do
          before { put absence_cat_path(@absence_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete absence_cat_path(@absence_cat) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @absence_cat_2 = @business.absence_cats.create(absence_code: "YY", maximum_days_year: 5, 
        						documentation_required: false, notes: "Change absence")
        @absence_cat_3 = @business.absence_cats.create(absence_code: "ZZ", maximum_days_year: 7, 
        						documentation_required: false, notes: "Previous absence", current: false)
        #Add definition for employee so that delete button will show / not show
      end
    
      describe "index page" do
      
        before { visit business_absence_cats_path(@business) }
      
        it { should have_selector('h1', text: 'Absence Types') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('.span1', text: @absence_cat.absence_code) }
        it { should have_selector('.span1', text: @absence_cat_2.absence_code) }
        it { should have_selector('.span1', text: "100") }          #Pay percentage
        it { should_not have_selector('.span1', text: "50") }
        it { should have_selector('.span1', text: "No") }           #Sickness
        it { should_not have_selector('.span1', text: "Yes") }
        it { should have_selector('.span1', text: "5") }           #Maximum days per year
        it { should_not have_selector('.span1', text: "--") }
        it { should have_selector('.span2', text: @absence_cat.notes) }
        it { should have_link('edit', href: edit_absence_cat_path(@absence_cat)) }
        it { should have_link('edit', href: edit_absence_cat_path(@absence_cat_2)) }
        it { should have_link('del', href: absence_cat_path(@absence_cat)) }
        pending "no delete button when absence type used in employee record"
        it { should have_link('Add an absence type', href: new_business_absence_cat_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
        
        describe "no listing if the absence_cat is not current" do
          it { should_not have_selector('.span1', text: @absence_cat_3.absence_code) }
        end
        
        describe "no delete link for absence_cats that have been previously used" do
          pending "Add when employee records in place"
        end
        
        it "should delete absence_cat (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.absence_cats, :count).by(-1)
        end
      end
      
      describe "index page with unpaid absence type" do
        before do
          @absence_cat_2.paid = 50
          @absence_cat_2.save
          visit business_absence_cats_path(@business)
        end
        
        it { should have_selector('.span1', text: "50") }
      end
      
      describe "index page with sickness absence type" do
        before do
          @absence_cat_2.sickness = true
          @absence_cat_2.save
          visit business_absence_cats_path(@business)
        end
        
        it { should have_selector('.span1', text: "Yes") }
      end
      
      describe "index page with no maximum days defined" do
        before do
          @absence_cat_2.maximum_days_year = nil
          @absence_cat_2.save
          visit business_absence_cats_path(@business)
        end
        
        it { should have_selector('.span1', text: "--") }
      end
      
      describe "index page with no certification required" do
        before do
          @absence_cat_2.documentation_required = true
          @absence_cat_2.save
          visit business_absence_cats_path(@business)
        end
        
        it { should have_selector('.span1', text: "Yes") }
      end 
            
      describe "index page with no former absence types" do
      
        before do
          @absence_cat_3.toggle!(:current)
          visit business_absence_cats_path(@business)
        end
        
        it { should_not have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
      end
      
      describe "old_absence_cats index" do
      
        before do
          @absence_cat_2.toggle!(:current) 
          visit business_old_absence_cats_path(@business)
        end
      
        it { should have_selector('h1', text: 'Old Absence Types') }
        it { should have_selector('h1', text: @business.name) }
        it { should_not have_selector('.span1', text: @absence_cat.absence_code) }
        it { should have_selector('.span1', text: @absence_cat_2.absence_code) }
        it { should have_selector('.span1', text: @absence_cat_3.absence_code) }
        it { should have_link('edit', href: edit_absence_cat_path(@absence_cat_3)) }
        it { should have_link('del', href: absence_cat_path(@absence_cat_3)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        it { should have_link('Current absence types', href: business_absence_cats_path(@business)) }
        
        describe "no delete link for absence cats that have already been used" do
          pending "add when employee records are running"
        end
        
        it "should delete division (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.absence_cats, :count).by(-1)
        end
      
      end
      
      describe "new page" do
      
        before { visit new_business_absence_cat_path(@business) }
      
        it { should have_selector('h1', text: 'New Absence Type') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#absence_cat_absence_code") }
        it { should have_selector("input#absence_cat_paid", value: 100) }
        it { should have_selector("input#absence_cat_sickness", value: false) }
        it { should have_selector("input#absence_cat_maximum_days_year") }
        it { should have_selector("input#absence_cat_documentation_required", value: true) }
        it { should have_selector("textarea#absence_cat_notes") }
        it { should have_selector('#absence_cat_created_by', type: 'hidden', value: @user.id) }
        it { should have_selector('#absence_cat_updated_by', type: 'hidden', value: @user.id) }
        it { should_not have_selector("input#absence_cat_current") }
        it { should have_link("Current absence types", href: business_absence_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        it { should have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
      
        describe "creating a new absence_cat" do
      
          before { fill_in :absence_code,  with: "BB" }
        
          it "should create an absence_cat" do
            expect { click_button "Create" }.to change(@business.absence_cats, :count).by(1)
            page.should have_selector('h1', text: "Absence Types")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'BB' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in :absence_code,  with: "" }
        
          it "should not create an absence_cat" do
            expect { click_button "Create" }.not_to change(AbsenceCat, :count)
            page.should have_selector('h1', text: 'New Absence Type')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "new page with no former absence_cats" do
      
        before do
          @absence_cat_3.toggle!(:current)
          visit new_business_absence_cat_path(@business)
        end
        
        it { should_not have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
      
      end
      
      describe "edit page" do
      
        before { visit edit_absence_cat_path(@absence_cat) }
      
        it { should have_selector('h1', text: 'Edit Absence Type') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#absence_cat_absence_code") }
        it { should have_selector("input#absence_cat_current") }
        it { should have_link("Current absence types", href: business_absence_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
        it { should_not have_selector(".instruction", text: "This absence type is not in your current list") }
        it { should have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
      
        describe "editing the absence code" do
      
          let(:new_code) { "MM" }
          before do
            fill_in :absence_code, with: new_code
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Absence Types') }
          it { should have_selector('div.alert.alert-success') }
          specify { @absence_cat.reload.absence_code.should == new_code }
          specify { @absence_cat.reload.updated_by.should == @user.id }
               
        end
      
        describe "absence_code that fails validation" do
      
          let(:new_code) { " " }
          before do
            fill_in :absence_code, with: new_code
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Absence Type') }
          it { should have_content('error') }
          specify { @absence_cat.reload.absence_code.should == @absence_cat.absence_code }
        end
      
        describe "declaring that the absence_code is no longer current" do
        
          before do
            uncheck "absence_cat_current"
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Absence Types') }
          it { should have_selector('div.alert.alert-success') }
          it { should_not have_selector('.span1', text: @absence_cat.absence_code) }
        end
      end
      
      describe "edit page with no former absence_cats" do
      
        before do
          @absence_cat_3.toggle!(:current)  #@absence_cat_3 is current
          visit edit_absence_cat_path(@absence_cat)
        end
        
        it { should_not have_link('View / reinstate old absence types', href: business_old_absence_cats_path(@business)) }
      
      end
      
      describe "edit page when absence_cat is not current" do
       
        before do
          visit edit_absence_cat_path(@absence_cat_3)  #@absence_cat_3 is not current
        end
        
        it { should have_selector(".instruction", text: "This absence type is not in your current list") }
      end
    end
  end
end
