require 'spec_helper'

describe "ContractPages" do
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @contract_cat = @business.contract_cats.create(contract: "FT")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_contract_cats_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_contract_cat_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_contract_cat_path(@contract_cat)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the contract_cat data" do
      
      describe "with a PUT request" do
        before { put contract_cat_path(@contract_cat) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete contract_cat_path(@contract_cat) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_contract_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_contract_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_contract_cat_path(@contract_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the contract_cats data" do
      
        describe "with a PUT request" do
          before { put contract_cat_path(@contract_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete contract_cat_path(@contract_cat) }
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
      
        before { visit business_contract_cats_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_contract_cat_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_contract_cat_path(@contract_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the contract_cats data" do
      
        describe "with a PUT request" do
          before { put contract_cat_path(@contract_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete contract_cat_path(@contract_cat) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @contract_cat_2 = @business.contract_cats.create(contract: "PT") 
        #add employee records - then prevent deletion if already used.
      end
    
      describe "index page" do
      
        before { visit business_contract_cats_path(@business) }
      
        it { should have_selector('h1', text: 'Contract Types') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('li', text: @contract_cat.contract) }
        it { should have_selector('li', text: @contract_cat_2.contract) }
        it { should have_link('edit', href: edit_contract_cat_path(@contract_cat)) }
        it { should have_link('edit', href: edit_contract_cat_path(@contract_cat_2)) }
        it { should have_link('del', href: contract_cat_path(@contract_cat)) }
        it { should have_link('Add a contract type', href: new_business_contract_cat_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        describe "no delete link for contract_cats that have already been used" do
          pending "Add when employee records are in place"
          #it { should_not have_link('del', href: contract_cat_path(@contract_cat_2)) }
        end
        
        it "should delete contract_cat (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.contract_cats, :count).by(-1)
        end
      end
      
      
      describe "new page" do
      
        before { visit new_business_contract_cat_path(@business) }
      
        it { should have_selector('h1', text: 'New Contract Type') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#contract_cat_contract") }
        it { should have_link("All contract types", href: business_contract_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new contract type" do
      
          before { fill_in "Contract",  with: "Casual" }
        
          it "should create a contract type" do
            expect { click_button "Create" }.to change(@business.contract_cats, :count).by(1)
            page.should have_selector('h1', text: "Contract Types")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Casual' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Contract",  with: "" }
        
          it "should not create a contract type" do
            expect { click_button "Create" }.not_to change(ContractCat, :count)
            page.should have_selector('h1', text: 'New Contract Type')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_contract_cat_path(@contract_cat) }
      
        it { should have_selector('h1', text: 'Edit Contract Type') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#contract_cat_contract") }
        it { should have_link("All contract types", href: business_contract_cats_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the contract type" do
      
          let(:new_contract) { "foobar" }
          before do
            fill_in 'Contract', with: new_contract
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Contract Types') }
          it { should have_selector('div.alert.alert-success') }
          specify { @contract_cat.reload.contract.should == new_contract }
          specify { @contract_cat.reload.updated_by.should == @user.id }
               
        end
      
        describe "contract type that fails validation" do
      
          let(:new_contract) { " " }
          before do
            fill_in 'Contract', with: new_contract
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Contract Type') }
          it { should have_content('error') }
          specify { @contract_cat.reload.contract.should == @contract_cat.contract }
        end
      end
    end
  end
end
