require 'spec_helper'

describe "CountryPages" do
  
  subject { page }
  
  before do
    @example = FactoryGirl.create(:nationality, nationality: 'Omani') 
    @currency = Currency.create(currency: 'Omani Riyals', code: 'OMR')
  end
  
  describe "when not logged in" do
    
    describe "nationality controller" do
    
      before { visit new_nationality_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit nationalities_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
    end  
     
    describe "currency controller" do
    
      before { visit new_currency_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit currencies_path }
      
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
    
    describe "nationality controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_nationality_path }
      
        it { should_not have_selector('title', text: 'New nationality') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit nationalities_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Nationalities#destroy action" do
          before { delete nationality_path(@example) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Nationalities#update action" do
        before { put nationality_path(@example) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "currency controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_currency_path }
      
        it { should_not have_selector('title', text: 'New currency') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit currencies_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Currencies#destroy action" do
          before { delete currency_path(@currency) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Currencies#update action" do
        before { put currency_path(@currency) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
  
  describe "when logged in as admin" do
    
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    
    describe "nationality controller" do
    
      describe "index" do
      
        before do  
          @example= FactoryGirl.create(:nationality, nationality: 'French')
          @example_1 = Nationality.create(nationality: 'British')
          @example_2 = Nationality.create(nationality: 'Algerian')
          visit nationalities_path
        end
      
        it { should have_selector('title', text: 'Nationalities') }
        it { should have_selector('h1', text: 'Nationalities') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_nationality_path(@example)) }
          it { should have_link('delete', href: nationality_path(@example)) }
          it { should have_link('Add', href: new_nationality_path) }
          it { should have_selector('ul.itemlist li:nth-child(3)', text: 'French') }
        
          describe "nationality already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a nationality" do
            expect { click_link('delete') }.to change(Nationality, :count).by(-1)
          end
          
          describe "when > 10 nationalities" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_nationality_path }
      
        it { should have_selector('title', text: 'New Nationality') }
        it { should have_selector('h1',    text: 'New Nationality') }
        it { should have_link('Back', href: nationalities_path) }
    
        describe "creating a new nationality" do
      
          before { fill_in "Nationality",  with: "British" }
        
          it "should create a nationality" do
            expect { click_button "Create" }.to change(Nationality, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Nationality",  with: "" }
        
          it "should not create a nationality" do
            expect { click_button "Create" }.not_to change(Nationality, :count)
            page.should have_selector('h1', text: 'New Nationality')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @example_3 = FactoryGirl.create(:nationality, nationality: 'Albanian')
          visit edit_nationality_path(@example_3)
        end
    
        it { should have_selector('title', text: 'Edit Nationality') }
        it { should have_selector('h1',    text: 'Edit Nationality') }
        it { should have_selector('input', value: @example_3.nationality) }
        it { should have_link('Back', href: nationalities_path) }
    
        describe "with invalid data" do
          before do
            fill_in 'Nationality', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Nationality') }
          it { should have_content('error') }
          specify { @example_3.reload.nationality.should == 'Albanian' }
        end
      
        describe "with valid data" do
      
          let(:new_nat) { "Croat" }
          before do
            fill_in 'Nationality', with: new_nat
            click_button "Save change" 
          end
      
          it { should have_selector('title', text: 'Nationalities') }
          it { should have_selector('div.alert.alert-success') }
          specify { @example_3.reload.nationality.should == new_nat }
        end
      end 
    end
    
    describe "currency controller" do
    
      describe "index" do
      
        before do  
          @currency_1 = Currency.create(currency: 'Pounds Sterling', code: 'GBP')
          @currency_2 = Currency.create(currency: 'Bahrain Dinars', code: 'BHD')
          visit currencies_path
        end
      
        it { should have_selector('title', text: 'Currencies') }
        it { should have_selector('h1', text: 'Currencies') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_currency_path(@currency)) }
          it { should have_link('delete', href: currency_path(@currency)) }
          it { should have_link('Add', href: new_currency_path) }
          it { should have_selector('ul.itemlist li:nth-child(2)', text: 'Pounds Sterling') }
        
          describe "currency already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a currency" do
            expect { click_link('delete') }.to change(Currency, :count).by(-1)
          end
          
          describe "when > 10 currencies" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_currency_path }
      
        it { should have_selector('title', text: 'New Currency') }
        it { should have_selector('h1',    text: 'New Currency') }
        it { should have_link('Back', href: currencies_path) }
    
        describe "creating a new Currency" do
      
          before do 
            fill_in "Currency",  with: "US Dollars"
            fill_in "Code", with: "USD"
          end
        
          it "should create a currency" do
            expect { click_button "Create" }.to change(Currency, :count).by(1)
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Code",  with: "" }
        
          it "should not create a currency" do
            expect { click_button "Create" }.not_to change(Currency, :count)
            page.should have_selector('h1', text: 'New Currency')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @currency_3 = Currency.create(currency: 'Saudi Riyals', code: 'SAR')
          visit edit_currency_path(@currency_3)
        end
    
        it { should have_selector('title', text: 'Edit Currency') }
        it { should have_selector('h1',    text: 'Edit Currency') }
        it { should have_selector('input', value: @currency_3.code) }
        it { should have_link('Back', href: currencies_path) }
    
        describe "with invalid data" do
          before do
            fill_in 'Code', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Currency') }
          it { should have_content('error') }
          specify { @currency_3.reload.code.should == 'SAR' }
        end
      
        describe "with valid data" do
      
          let(:new_curr) { "Euro" }
          let(:new_code) { "EUR" }
          before do
            fill_in 'Currency', with: new_curr
            fill_in 'Code', with: new_code
            click_button "Save change" 
          end
      
          it { should have_selector('title', text: 'Currencies') }
          it { should have_selector('div.alert.alert-success') }
          specify { @currency_3.reload.code.should == new_code }
        end
      end 
    end
  end
end
