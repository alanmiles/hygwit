require 'spec_helper'

describe "DisciplinaryPages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @disciplinary_cat = @business.disciplinary_cats.create(category: "Poor Performance")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_disciplinary_cats_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_disciplinary_cat_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_disciplinary_cat_path(@disciplinary_cat)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the disciplinary_cat data" do
      
      describe "with a PUT request" do
        before { put disciplinary_cat_path(@disciplinary_cat) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete disciplinary_cat_path(@disciplinary_cat) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_disciplinary_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_disciplinary_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_disciplinary_cat_path(@disciplinary_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the disciplinary_cats data" do
      
        describe "with a PUT request" do
          before { put disciplinary_cat_path(@disciplinary_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete disciplinary_cat_path(@disciplinary_cat) }
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
      
        before { visit business_disciplinary_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_disciplinary_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_disciplinary_cat_path(@disciplinary_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the disciplinary_cats data" do
      
        describe "with a PUT request" do
          before { put disciplinary_cat_path(@disciplinary_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete disciplinary_cat_path(@disciplinary_cat) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @disciplinary_cat_2 = @business.disciplinary_cats.create(category: "Fighting") 
        #add employee records - then prevent deletion if already used.
      end
    
      describe "index page" do
      
        before { visit business_disciplinary_cats_path(@business) }
      
        it { should have_selector('h1', text: 'Disciplinary Categories') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('li', text: @disciplinary_cat.category) }
        it { should have_selector('li', text: @disciplinary_cat_2.category) }
        it { should have_link('edit', href: edit_disciplinary_cat_path(@disciplinary_cat)) }
        it { should have_link('edit', href: edit_disciplinary_cat_path(@disciplinary_cat_2)) }
        it { should have_link('del', href: disciplinary_cat_path(@disciplinary_cat)) }
        it { should have_link('Add a disciplinary category', href: new_business_disciplinary_cat_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        describe "no delete link for disciplinary_cats that have already been used" do
          pending "Add when employee records are in place"
          #it { should_not have_link('del', href: disciplinary_cat_path(@disciplinary_cat_2)) }
        end
        
        it "should delete disciplinary_cat (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.disciplinary_cats, :count).by(-1)
        end
      end
      
      
      describe "new page" do
      
        before { visit new_business_disciplinary_cat_path(@business) }
      
        it { should have_selector('h1', text: 'New Disciplinary Category') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#disciplinary_cat_category") }
        it { should have_link("All disciplinary categories", href: business_disciplinary_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new disciplinary category" do
      
          before { fill_in "Category",  with: "Poor attendance" }
        
          it "should create a disciplinary category" do
            expect { click_button "Create" }.to change(@business.disciplinary_cats, :count).by(1)
            page.should have_selector('h1', text: "Disciplinary Categories")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Poor attendance' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Category",  with: "" }
        
          it "should not create a disciplinary category" do
            expect { click_button "Create" }.not_to change(DisciplinaryCat, :count)
            page.should have_selector('h1', text: 'New Disciplinary Category')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_disciplinary_cat_path(@disciplinary_cat) }
      
        it { should have_selector('h1', text: 'Edit Disciplinary Category') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#disciplinary_cat_category") }
        it { should have_link("All disciplinary categories", href: business_disciplinary_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the disciplinary category" do
      
          let(:new_cat) { "foobar" }
          before do
            fill_in 'Category', with: new_cat
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Disciplinary Categories') }
          it { should have_selector('div.alert.alert-success') }
          specify { @disciplinary_cat.reload.category.should == new_cat }
          specify { @disciplinary_cat.reload.updated_by.should == @user.id }
               
        end
      
        describe "disciplinary category that fails validation" do
      
          let(:new_cat) { " " }
          before do
            fill_in 'Category', with: new_cat
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Disciplinary Category') }
          it { should have_content('error') }
          specify { @disciplinary_cat.reload.category.should == @disciplinary_cat.category }
        end
      end
    end
  end
end
