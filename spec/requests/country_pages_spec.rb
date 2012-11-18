require 'spec_helper'

describe "CountryPages" do
  
  subject { page }
  
  before do
    @absence_type = FactoryGirl.create(:absence_type, absence_code: "SF")
    @example = FactoryGirl.create(:nationality, nationality: 'Omani', created_by: 999999)
    @currency = Currency.create(currency: 'Omani Riyals', code: 'OMR')
    @country = Country.create(country: "Oman", currency_id: @currency.id, nationality_id: @example.id, rules: "Gulf")
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
      
      describe "when trying to change the nationality data" do
      
        describe "with a PUT request" do
          before { put nationality_path(@example) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete nationality_path(@example) }
          specify { response.should redirect_to(root_path) }        
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
      
      describe "when trying to change the currency data" do
      
        describe "with a PUT request" do
          before { put currency_path(@currency) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete currency_path(@currency) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end 
    
    describe "country controller" do
    
      before { visit new_country_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit countries_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the country data" do
      
        describe "with a PUT request" do
          before { put country_path(@country) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete country_path(@country) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end 
          
  end
  
  describe "when logged in as non-admin" do
  
    before do
      user = FactoryGirl.create(:user, name: "Country checker", email: "cchecker@example.com")
      sign_in user
    end
    
    describe "nationality controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_nationality_path }
      
        it { should_not have_selector('title', text: 'New Nationality') }
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
      
        it { should_not have_selector('title', text: 'New Currency') }
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
    
    
    
    describe "countries controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_path }
      
        it { should_not have_selector('title', text: 'New Country') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit countries_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Countries#destroy action" do
          before { delete country_path(@country) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Countries#update action" do
        before { put country_path(@country) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    
    
    
  end
  
  describe "when logged in as admin" do
    
    before do
      @admin = FactoryGirl.create(:admin, name: "Country Admin", email: "countryadmin@example.com")
      sign_in @admin
      
    end
    
    describe "nationality controller" do
    
      describe "index" do
      
        before do  
          @example= FactoryGirl.create(:nationality, nationality: 'French', created_by: 999999)
          @example_1 = Nationality.create(nationality: 'British', created_by: @admin.id)     #created by this user but linked to country
          @example_2 = Nationality.create(nationality: 'Algerian', created_by: 999999)    #not created by this user
          @example_3 = Nationality.create(nationality: 'Chinese', created_by: @admin.id)
          @currency_1 = Currency.create(currency: 'Pounds', code: 'GBP')
          @country_1 = Country.create(country: 'UK', nationality_id: @example_1.id, currency_id: @currency_1.id)
          visit nationalities_path
        end
      
        it { should have_selector('title', text: 'Nationalities') }
        it { should have_selector('h1', text: 'Nationalities') }
        it { should_not have_selector('#statistics', text: 'unlinked') }  #superuser only
        it { should_not have_selector('#recent-adds') }
        it { should_not have_selector('.recent', text: "*") }
      
        describe "list " do
      
          it { should have_link('change', href: edit_nationality_path(@example)) }
          it { should_not have_link('delete', href: nationality_path(@example)) }    #because not created by current user
          it { should_not have_link('delete', href: nationality_path(@example_1)) }  #because already linked to country
          it { should have_link('delete', href: nationality_path(@example_3)) }  	   #because created by current user
          it { should have_link('Add', href: new_nationality_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'French') }
        
          it "should delete nationality (when delete button is shown)" do
            expect { click_link('delete') }.to change(Nationality, :count).by(-1)
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
      
      describe "deletions" do
      
        before do  
          @nationality_4 = Nationality.create(nationality: 'New Zealander', created_by: 999999)
          @nationality_2 = Nationality.create(nationality: 'Bahraini', created_by: 999999)
          @nationality_5 = Nationality.create(nationality: 'Nigerian', created_by: @admin.id)
          @currency = Currency.create(currency: 'Bahraini Dinars', code: 'BHD')
          @country = Country.create(country: 'Bahrain', nationality_id: @nationality_2.id, currency_id: @currency.id)
        end 
          
        describe "non-deletion of nationalities linked to countries" do
          before { delete nationality_path(@nationality_2) }
          specify { response.should redirect_to root_path }      
        end
          
        describe "non-deletion of nationalities not created by current_user admin" do
          pending("strength test to make sure record can't be deleted from URL")
          #before { delete nationality_path(@nationality_4) }
          #specify { response.should redirect_to(nationalities_path) }  
        end
        
        describe "deletion of nationalities created by current_user admin" do
          pending("strength test to make sure owned record can be deleted")
          #before { delete nationality_path(@nationality_5) }
          #specify { response.should redirect_to(nationalities_path) }  
        end
        
      end  
    end
    
    describe "currency controller" do
    
      describe "index" do
      
        before do  
          @currency_1 = Currency.create(currency: 'Pounds Sterling', code: 'GBP', created_by: 999999)
          @currency_2 = Currency.create(currency: 'Bahrain Dinars', code: 'BHD', created_by: @admin.id)
          @currency_3 = Currency.create(currency: 'Afghani', code: 'AFN', created_by: @admin.id)
          @nationality = Nationality.create(nationality: 'Bahraini')
          @country = Country.create(country: 'Bahrain', nationality_id: @nationality.id, currency_id: @currency_2.id)
          visit currencies_path
        end
      
        it { should have_selector('title', text: 'Currencies') }
        it { should have_selector('h1', text: 'Currencies') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_currency_path(@currency)) }
          it { should_not have_link('delete', href: currency_path(@currency_1)) }  #because created by a different user
          it { should_not have_link('delete', href: currency_path(@currency_2)) }  #because already in use
          it { should have_link('delete', href: currency_path(@currency_3)) } 
          it { should have_link('Add', href: new_currency_path) }
          it { should have_selector('ul.itemlist li:nth-child(3)', text: 'Pounds Sterling') }
          it { should_not have_selector('#statistics', text: 'unlinked') }  #superuser only
          it { should_not have_selector('#recent-adds') }
          it { should_not have_selector('.recent', text: "*") }
        
          it "should be able to delete a currency" do
            expect { click_link('delete') }.to change(Currency, :count).by(-1)
          end
          
          describe "when > 10 currencies" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
          
          describe "alert when currencies are not linked to countries" do
            pending("shows how many unlinked or that all are linked")
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
      
      describe "deletions" do
      
        before do  
          @currency_4 = Currency.create(currency: 'New Zealand Dollar', code: 'NZD')
          @currency_2 = Currency.create(currency: 'Bahrain Dinars', code: 'BHD')
          @nationality = Nationality.create(nationality: 'Bahraini')
          @country = Country.create(country: 'Bahrain', nationality_id: @nationality.id, currency_id: @currency_2.id)
        end 
          
        describe "non-deletion of currencies linked to countries" do
          before { delete currency_path(@currency_2) }
          specify { response.should redirect_to(root_path) }      
        end
          
        describe "deletion of currencies unlinked to countries" do
          before { delete currency_path(@currency_4) }
          specify { response.should redirect_to(currencies_path) }  
        end
      end 
    end
    
    
    
    describe "country controller" do
    
      before do
        @currency_1 = Currency.create(currency: 'Pounds Sterling', code: 'GBP')
        @currency_2 = Currency.create(currency: 'Bahraini Dinars', code: 'BHD')
        @nationality_1 = Nationality.create(nationality: 'British')
        @nationality_2 = Nationality.create(nationality: 'Bahraini')
        @country_1 = Country.create(country: 'UK', 
           currency_id: @currency_1.id, nationality_id: @nationality_1.id, created_by: 999999)
        @country_2 = Country.create(country: 'Bahrain', 
           currency_id: @currency_2.id, nationality_id: @nationality_2.id, created_by: @admin.id)
      end
      
      
      describe "index" do
      
        before do  
          visit countries_path
        end
     
        it { should have_selector('title', text: 'Countries') }
        it { should have_selector('h1', text: 'Countries') }
      
        describe "list " do
      
          it { should have_link('change', href: edit_country_path(@country)) }
          it { should_not have_link('delete', href: country_path(@country_1)) }
          it { should have_link('delete', href: country_path(@country_2)) }
          it { should have_link('Add', href: new_country_path) }
          it { should have_link("settings", href: country_path(@country)) }
          it { should have_selector('ul.itemlist li:nth-child(3)', text: 'UK') }
          it { should_not have_selector('#statistics', text: 'unlinked') }
          it { should_not have_selector('#recent-adds') }
          it { should_not have_selector('.recent', text: "*") }
          it { should_not have_selector('.incomplete', text: "!") }
          it { should_not have_selector('#still-incomplete') }  
        
          
          describe "when > 10 countries" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
      
      describe "show" do
      
        before { visit country_path(@country) }
        
        it { should have_selector('title', text: @country.country) }
        it { should have_selector('h1',		 text: @country.country) }
        it { should_not have_link('Edit', href: edit_country_path(@country)) } #unless one of the country's administrators
        it { should have_link('All countries', href: countries_path) } 
        it { should have_selector('#ramadan-day', text: 'Ramadan') } 
        it { should have_selector('#ramadan-week', text: 'Ramadan') }
        it { should have_selector('#sick-accrual', text: 'Sickness accruals') }
        it { should have_selector('#gratuity', text: "Leavers' gratuity applies?") } 
        it { should have_selector('h3',		 text: 'Local Labor Law Regulations') } 
        it { should have_selector('h3',		 text: 'Absence codes') }
        it { should_not have_link('Add an absence type', href: new_country_country_absence_path(@country)) }
        it { should_not have_link('edit', href: edit_country_absence_path(@country.country_absences.first)) } #not registered cntry admin
        it { should_not have_link('del', href: country_absence_path(@country.country_absences.first)) } #not registered country admin
        it { should_not have_selector("#completion", text: "SETTINGS") }
        it { should_not have_selector("#update-status", text: "When a country administrator emails to tell you") }
        it { should_not have_selector("#update-status", text: "As a country administrator it's your job") }
        it { should have_selector("#update-status", text: "You're not registered as an administrator") }
        it { should_not have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        it { should_not have_selector('.recent', text: "*") }
        
        
        describe "where country does not follow 'Gulf' rules" do
          before { visit country_path(@country_1) }
        
          it { should_not have_selector('#ramadan-day', text: 'Ramadan') } 
          it { should_not have_selector('#ramadan-week', text: 'Ramadan') }
          it { should_not have_selector('#sick-accrual', text: 'Sickness accruals') }
          it { should_not have_selector('#gratuity', text: "Leavers' gratuity applies?") } 
        end  
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_path }
      
        it { should have_selector('title', text: 'New Country') }
        it { should have_selector('h1',    text: 'New Country') }
        it { should have_link('Back', href: countries_path) }
    
        describe "creating a new Country" do
      
          before do 
            5.times { FactoryGirl.create(:absence_type) }
            fill_in "Country", with: "Scotland"
            select "GBP (Pounds Sterling)",  from: "country_currency_id"
            select "British", from: "Nationality"
          end
        
          it "should create a country and redirect to the 'show' page" do
            expect { click_button "Create" }.to change(Country, :count).by(1)
            page.should have_selector('h1', text: 'Scotland')
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Country",  with: "" }
        
          it "should not create a country" do
            expect { click_button "Create" }.not_to change(Country, :count)
            page.should have_selector('h1', text: 'New Country')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @currency_3 = Currency.create(currency: 'Saudi Riyals', code: 'SAR')
          @nationality_3 = Nationality.create(nationality: 'Saudi')
          @country_3 = Country.create(country: 'Saudi Arabia', nationality_id: @nationality_3.id, currency_id: @currency_3.id)
          visit edit_country_path(@country_3)
        end
    
        it { should have_selector('title', text: 'Edit Labor Law Regulations') }
        it { should have_selector('h1',    text: 'Edit Labor Law Regulations') }
        it { should have_selector('input', value: @country_3.country) }
        it { should have_link('List', href: countries_path) }
        it { should_not have_selector('#ramadan-day', text: "Ramadan") } 
        it { should_not have_selector('#ramadan-week', text: "Ramadan") }
        it { should_not have_selector('#sick-accrual', text: "sickness accrual") }
        it { should_not have_selector("#completion", text: "Are all settings complete?") }         
        
        describe "for countries with 'Gulf' rules" do
          before { visit edit_country_path(@country) }
          it { should have_selector('#ramadan-day', text: "Ramadan") } 
          it { should have_selector('#ramadan-week', text: "Ramadan") }
          it { should have_selector('#sick-accrual', text: "sickness accrual") }        
        end
                
        describe "with invalid data" do
          before do
            fill_in 'Country', with: " "
            click_button "Save changes"
          end
        
          it { should have_selector('title', text: 'Edit Labor Law Regulations') }
          it { should have_content('error') }
          specify { @country_3.reload.country.should == 'Saudi Arabia' }
        end
      
        describe "with valid data - redirecting to 'show' page" do
      
          let(:new_country) { "Kingdom of Saudi Arabia" }
     
          before do
            fill_in 'Country', with: new_country
            click_button "Save changes" 
          end
      
          it { should have_selector('title', text: 'Kingdom of Saudi Arabia') }
          it { should have_selector('div.alert.alert-success') }
          specify { @country_3.reload.country.should == new_country }
        end
      end 
    end
    
    describe "when a country administrator" do
    
      before do 
        CountryAdmin.create!(user_id: @admin.id, country_id: @country.id)
      end
      
      describe "show" do
      
        before { visit country_path(@country) }
        
        it { should have_link('Edit regulations', href: edit_country_path(@country)) }
        it { should have_link('Add an absence type', href: new_country_country_absence_path(@country)) }
        it { should_not have_selector("#update-status", text: "When a country administrator emails to tell you") }
        it { should have_selector("#update-status", text: "As a country administrator it's your job") }
        it { should_not have_selector("#update-status", text: "You're not registered as an administrator") }
        it { should_not have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        it { should_not have_selector('.recent', text: "*") }
        it { should have_link('edit', href: edit_country_absence_path(@country.country_absences.first)) } 
        it { should have_link('del', href: country_absence_path(@country.country_absences.first)) }
      
        describe "deleting an absence code" do
        
          it "should be from the correct model" do
            expect { click_link('del') }.to change(CountryAbsence, :count).by(-1)
          end
        end  
      end
    end
  end
  
  describe "when logged in as superuser" do
    
    before do
      @superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
      sign_in @superuser 
    end
    
    describe "nationality controller" do
    
      describe "index" do
      
        before do  
          @example= FactoryGirl.create(:nationality, nationality: 'French')
          @example_1 = Nationality.create(nationality: 'British', created_by: @superuser.id)
          @example_2 = Nationality.create(nationality: 'Algerian', created_by: 999999)
          @example_3 = Nationality.create(nationality: 'Chinese', created_by: @superuser.id)
          @currency_1 = Currency.create(currency: 'Pounds', code: 'GBP')
          @country_1 = Country.create(country: 'UK', nationality_id: @example_1.id, currency_id: @currency_1.id)
          visit nationalities_path
        end
        
        it { should have_selector('#statistics', text: 'unlinked') }
        it { should have_selector('#recent-adds') }
        it { should have_selector('.recent', text: "*") }
        it { should have_link('delete', href: nationality_path(@example)) }    #although not created by current user
        it { should_not have_link('delete', href: nationality_path(@example_1)) }  #because already linked to country
        it { should have_link('delete', href: nationality_path(@example_3)) }  #when created by current user
      end
    
    end
    
    describe "currencies controller" do
    
      describe "index" do
      
        before do  
          @currency_1 = Currency.create(currency: 'Pounds Sterling', code: 'GBP', created_by: 999999)
          @currency_2 = Currency.create(currency: 'Bahrain Dinars', code: 'BHD', created_by: @superuser.id)
          @currency_3 = Currency.create(currency: 'Australian Dollar', code: 'AUD', created_by: @superuser.id)
          @nationality = Nationality.create(nationality: 'Bahraini')
          @country = Country.create(country: 'Bahrain', nationality_id: @nationality.id, currency_id: @currency_2.id)
          visit currencies_path
        end
      
        it { should have_selector('#statistics', text: 'unlinked') }
        it { should have_selector('#recent-adds') }
        it { should have_selector('.recent', text: "*") }
        it { should have_link('delete', href: currency_path(@currency_1)) }  #although created by a different user
        it { should_not have_link('delete', href: currency_path(@currency_2)) }  #because already in use
        it { should have_link('delete', href: currency_path(@currency_3)) } 
      
      end
    
    end
    
    describe "countries controller" do
    
      before do
        @currency_1 = Currency.create(currency: 'Pounds Sterling', code: 'GBP')
        @currency_2 = Currency.create(currency: 'Bahraini Dinars', code: 'BHD')
        @nationality_1 = Nationality.create(nationality: 'British')
        @nationality_2 = Nationality.create(nationality: 'Bahraini')
        @country_1 = Country.create(country: 'UK', 
           currency_id: @currency_1.id, nationality_id: @nationality_1.id, created_by: 999999)
        @country_2 = Country.create(country: 'Bahrain', 
           currency_id: @currency_2.id, nationality_id: @nationality_2.id, created_by: @superuser.id)
      end
      
      describe "index" do
      
        before do  
          visit countries_path
        end
        
        it { should have_link('delete', href: country_path(@country_1)) }
        it { should have_link('delete', href: country_path(@country_2)) }
        it { should have_selector('#recent-adds') }
        it { should have_selector('.recent', text: "*") }
        it { should have_selector('.incomplete', text: "!") } 
        it { should have_selector('#still-incomplete') } 
        it "should be able to delete a country" do
          expect { click_link('delete') }.to change(Country, :count).by(-1)
        end
      
      end
    
      describe "edit" do
    
        before do
          @currency_3 = Currency.create(currency: 'Saudi Riyals', code: 'SAR')
          @nationality_3 = Nationality.create(nationality: 'Saudi')
          @country_3 = Country.create(country: 'Saudi Arabia', nationality_id: @nationality_3.id, currency_id: @currency_3.id)
          visit edit_country_path(@country_3)
        end
        
        it { should have_selector("#completion", text: "Are all settings complete?") }
      end
      
      describe "show" do
      
        before { visit country_path(@country) }
        
        it { should have_selector("#completion", text: "SETTINGS") }
        it { should have_link('Edit regulations', href: edit_country_path(@country)) }
        it { should have_link('Add an absence type', href: new_country_country_absence_path(@country)) }
        it { should have_selector("#update-status", text: "When a country administrator emails to tell you") }
        it { should_not have_selector("#update-status", text: "As a country administrator it's your job") }
        it { should_not have_selector("#update-status", text: "You're not registered as an administrator") }
        it { should have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        it { should have_selector('.recent', text: "*") }
        it { should have_link('edit', href: edit_country_absence_path(@country.country_absences.first)) }
        it { should have_link('del', href: country_absence_path(@country.country_absences.first)) }
      end
    end
  end
end
