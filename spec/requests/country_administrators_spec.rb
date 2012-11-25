require 'spec_helper'

describe "CountryAdministrators" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "Saudi")
    @currency = FactoryGirl.create(:currency, currency: "Saudi Riyals", code: "SAR")
    @country = FactoryGirl.create(:country, country: "Saudi Arabia", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, rules: "Gulf", gratuity_applies: true)
    @holiday = @country.holidays.create(name: "Eid Al Adha", start_date: "2012-10-31", end_date: "2012-11-02")
    @gratuity_line = @country.gratuity_formulas.create(service_years_from: 0, service_years_to: 3,
    																			termination_percentage: 50, resignation_percentage: 0)
  end
  
  describe "when not logged in" do
  
    describe "Holidays controller" do
    
      describe "when trying to enter a new holiday" do 
      
        before { visit new_country_holiday_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
   
      end
       
      describe "when trying to access the index" do
    
        before { visit country_holidays_path(@country) }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the holiday data" do
      
        describe "with a PUT request" do
          before { put holiday_path(@holiday) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete holiday_path(@holiday) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end 
    
    describe "GratuityFormulas controller" do
    
      describe "when trying to enter a new gratuity formula" do 
      
        before { visit new_country_gratuity_formula_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
   
      end
       
      describe "when trying to access the index" do
    
        before { visit country_gratuity_formulas_path(@country) }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the gratuity data" do
      
        describe "with a PUT request" do
          before { put gratuity_formula_path(@gratuity_line) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete gratuity_formula_path(@gratuity_line) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end 
 
  end
  
  describe "when logged in as non-admin" do
    
    before do
      user = FactoryGirl.create(:user, name: "Non Admin", email: "nonadmin@example.com") 
      sign_in user
    end
    
    describe "holidays controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_holiday_path(@country) }
      
        it { should_not have_selector('title', text: 'New National Holiday') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_holidays_path(@country) }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the Holidays#destroy action" do
          before { delete holiday_path(@holiday) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the Holidays#update action" do
        before { put holiday_path(@holiday) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "Gratuity Formulas controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_gratuity_formula_path(@country) }
      
        it { should_not have_selector('title', text: 'New Gratuity Rule') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_gratuity_formulas_path(@country) }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the GratuityFormula#destroy action" do
          before { delete gratuity_formula_path(@gratuity_line) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the GratuityFormula#update action" do
        before { put gratuity_formula_path(@gratuity_line) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
  end
  
  describe "when logged in as admin" do
  
    before do
      @admin = FactoryGirl.create(:admin, name: "An Admin", email: "anadmin@example.com")
      sign_in @admin
    end
    
    describe "but not a country administrator" do
    
      describe "Holidays controller" do
      
        describe "index of holidays for country" do
      
          before { visit country_holidays_path(@country) }
        
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "National Holidays: #{@country.country}") }
          it { should have_selector('h1', text: 'National Holidays') }
          it { should_not have_link('Add a national holiday', href: new_country_holiday_path(@country)) }
          it { should have_link('Back to main settings page', href: country_path(@country)) }
          it { should_not have_link('edit', href: edit_holiday_path(@country.holidays.first)) }
          it { should_not have_link('delete', href: holiday_path(@country.holidays.first)) }
          it { should_not have_selector('#recent-adds', text: "additions (*) in past 7 days") }
          it { should_not have_selector('.recent', text: "*") }
          it { should_not have_selector('.instruction', text: "Add the PUBLIC HOLIDAYS") }
          it { should have_selector('.instruction', text: "You're not registered as an administrator") }
          it { should have_selector('.instruction', text: "We're still looking for country administrators") }
        end
    
        describe "visiting index when there's a full complement of country administrators" do
          
          before do
            @user_2 = FactoryGirl.create(:user, name: "User2", email: "user2@example.com",
                                         password: "foobar", password_confirmation: "foobar")
            @user_3 = FactoryGirl.create(:user, name: "User3", email: "user3@example.com",
                                         password: "foobar", password_confirmation: "foobar")
            @user_2.toggle!(:admin)
            @user_3.toggle!(:admin)
            CountryAdmin.create(user_id: @user_2.id, country_id: @country.id)
            CountryAdmin.create(user_id: @user_3.id, country_id: @country.id)
          end
        
          before { visit country_path(@country) }
          it { should_not have_selector('.instruction', text: "We're still looking for country administrators") }
        
        end
      
        describe "when trying to access the 'new' page" do
    
          before { visit new_country_holiday_path(@country) }
      
          it { should_not have_selector('title', text: 'New National Holiday') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the Holidays#destroy action" do
     
            before { delete holiday_path(@holiday) }
            specify { response.should redirect_to(user_path(@admin)) }        
          end
    
        end
    
        describe "submitting a PUT request to the Holidays#update action" do
       
          before { put holiday_path(@holiday) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
      
      end
      
      describe "Gratuity Formulas controller" do
      
        describe "gratuity table (index) for country" do
      
          before { visit country_gratuity_formulas_path(@country) }
        
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "Gratuity Table: #{@country.country}") }
          it { should have_selector('h1', text: 'Gratuity Table') }
          it { should_not have_link('Add a line to the table', href: new_country_gratuity_formula_path(@country)) }
          it { should have_link('Back to main settings page', href: country_path(@country)) }
          it { should_not have_link('edit', href: edit_gratuity_formula_path(@country.gratuity_formulas.first)) }
          it { should_not have_link('delete', href: gratuity_formula_path(@country.gratuity_formulas.first)) }
          it { should_not have_selector('#recent-adds') }
          it { should_not have_selector('.recent', text: "*") }
          it { should_not have_selector('.instruction', text: "EXPATRIATE LEAVER GRATUITIES") }
          it { should have_selector('.instruction', text: "You're not registered as an administrator") }
          it { should have_selector('.instruction', text: "We're still looking for country administrators") }
        end
      
        describe "when trying to access the 'new' page" do
    
          before { visit new_country_gratuity_formula_path(@country) }
      
          it { should_not have_selector('title', text: 'New Gratuity Rule') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
        
        describe "when trying to access the 'edit' page" do
    
          before { visit edit_gratuity_formula_path(@gratuity_line) }
      
          it { should_not have_selector('title', text: 'Edit Gratuity Rule') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the gratuity_formulas#destroy action" do
     
            before { delete gratuity_formula_path(@gratuity_line) }
            specify { response.should redirect_to(user_path(@admin)) }        
          end
    
        end
    
        describe "submitting a PUT request to the gratuity_formulas#update action" do
       
          before { put gratuity_formula_path(@gratuity_line) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
      
      end
      
    end
    
    describe "and a country administrator" do
    
      before { CountryAdmin.create(user_id: @admin.id, country_id: @country.id) }
      
      describe "Holidays controller" do
      
        describe "add a new public holiday for the country" do
      
          before { visit new_country_holiday_path(@country.id) }
        
          it { should have_selector('title', text: 'New National Holiday') }
          it { should have_selector('h1', text: 'New National Holiday') }
          it { should have_selector('h1', text: @country.country) }
          it { should have_link('All national holidays', href: country_holidays_path(@country)) }
          it { should have_link("Country set-up page", href: country_path(@country)) }
      
          describe "with valid data" do
        
            before do        
              fill_in "Holiday name", with: "Eid Al Adha"
              fill_in "Start date", with: "2013-08-03"
              fill_in "End date", with: "2013-08-05"
            end
          
            it "should create a new holiday for the country" do
              expect { click_button "Create" }.to change(Holiday, :count).by(1)
              page.should have_selector('h1', text: 'National Holidays')
              page.should have_selector('h1', text: @country.country)
              page.should have_selector('title', text: "National Holidays: #{@country.country}")
            end 
          end
        
          describe "with invalid data" do
           
            before do
              fill_in "Holiday name", with: "  "
            end
          
            it "should not create a new holiday for the country" do
              expect { click_button "Create" }.not_to change(Holiday, :count)
              page.should have_selector('h1', text: 'New National Holiday')
              page.should have_selector('h1', text: @country.country)
              page.should have_content('error')    
            end
          end
        end
      
        describe "index of holidays for country" do
      
          before { visit country_holidays_path(@country) }
        
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "National Holidays: #{@country.country}") }
          it { should have_selector('h1', text: 'National Holidays') }
          it { should have_link('Add a national holiday', href: new_country_holiday_path(@country)) }
          it { should have_link('Back to main settings page', href: country_path(@country)) }
          it { should have_link('edit', href: edit_holiday_path(@country.holidays.first)) }
          it { should have_link('delete', href: holiday_path(@country.holidays.first)) }
          it { should have_selector('#recent-adds') }
          it { should have_selector('.recent', text: "*") }
          it { should have_selector('.instruction', text: "Add the PUBLIC HOLIDAYS") }
          it { should have_selector('.instruction', text: "In the Muslim world") }   #Gulf rules apply
          it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
          it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
        
          describe "moving to the holiday edit link in the correct country" do
            before { click_link 'edit' }
          
            it { should have_selector('title', text: "Edit National Holiday") }
            it { should have_selector('h1', text: @country.country) }
        
          end
        
          describe "deleting a national holiday" do
        
            it "should be from the correct model" do
              expect { click_link('del') }.to change(Holiday, :count).by(-1)            
            end
          end
        end
      
        describe "not Muslim rules for holidays" do
          before do
            @country.rules = ""
            @country.save 
          end
        
          before { visit country_holidays_path(@country) }
          it { should_not have_selector('.instruction', text: "In the Muslim world") } 
        end
      
        describe "pagination on holidays index page" do
      
          before do
            @date = Date.today
            for i in 1..20
              @date = @date + i
              @country.holidays.create(name: "Holiday_#{i}", start_date: @date, end_date: @date)
            end
          end
        
          before { visit country_holidays_path(@country) }
        
          it { should have_selector('li', text: 'Holiday_10') }  
          pending ("Test to ensure in descending order")
        
          it { should have_selector('div.pagination') }
      
        end
      
        describe "editing one of the country's holidays" do
      
          let(:holiday) { @country.holidays.last }
          before { visit edit_holiday_path(holiday) }
        
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "Edit National Holiday") }
          it { should have_selector('h1', text: 'Edit National Holiday') }
          it { should have_link('All national holidays', href: country_holidays_path(@country)) }
          it { should have_link('Country set-up page', href: country_path(@country)) }   
      
          describe "updating with valid data" do
          
            before do
              fill_in "Holiday name", with: "Eid Al Fitr"
              click_button "Save changes"
            end
          
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "National Holidays: #{@country.country}") }
            it { should have_selector('h1', text: 'National Holidays') }
            specify { holiday.reload.name.should == 'Eid Al Fitr' }    
                 
          end
        
          describe "updating with invalid data" do
        
            before do
              fill_in "Holiday name", with: " "
              click_button "Save changes"
            end
          
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: 'Edit National Holiday') }
            it { should have_content('error') }
            specify { holiday.reload.name.should == "Eid Al Adha" }   
          end
        end
      end
      
      describe "GratuityFormulas controller" do
       
        describe "when gratuity is switched off" do
          
          before do
            @country.gratuity_applies = false
            @country.save
          end
        
          describe "when trying to access the 'new' page" do
    
            before { visit new_country_gratuity_formula_path(@country) }
      
            it { should_not have_selector('title', text: 'New Gratuity Rule') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: 'Leaver gratuities are switched off for this country')
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
          
          describe "when trying to access the index page" do
          
            before { visit country_gratuity_formulas_path(@country) }
      
            it { should_not have_selector('title', text: 'Gratuity Table') }
            it "should render the admin home-page" do
              page.should have_selector('.alert', text: 'Leaver gratuities are switched off for this country')
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          
          end
        
        end
        
        describe "when the gratuity control is switched on" do
        
          describe "add a new gratuity formula for the country" do
      
            before { visit new_country_gratuity_formula_path(@country.id) }
        
            it { should have_selector('title', text: 'New Gratuity Rule') }
            it { should have_selector('h1', text: 'New Gratuity Rule') }
            it { should have_selector('h1', text: @country.country) }
            it { should have_link('Full gratuity table', href: country_gratuity_formulas_path(@country)) }
            it { should have_link("Country set-up page", href: country_path(@country)) }
      
            describe "with valid data" do
        
              before do        
                fill_in "Formula applies to", with: 3
                fill_in "up to but not including", with: 5
                fill_in "terminates", with: 100
                fill_in "resigns", with: 50
              end
          
              it "should create a new gratuity line for the country" do
                expect { click_button "Create" }.to change(GratuityFormula, :count).by(1)
                page.should have_selector('h1', text: 'Gratuity Table')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: "Gratuity Table: #{@country.country}")
              end 
            end
        
            describe "with invalid data" do
           
              before do
                fill_in "Formula applies to", with: "  "
              end
          
              it "should not create a new gratuity line for the country" do
                expect { click_button "Create" }.not_to change(GratuityFormula, :count)
                page.should have_selector('h1', text: 'New Gratuity Rule')
                page.should have_selector('h1', text: @country.country)
                page.should have_content('error')    
              end
            end
          end
        
          describe "Gratuity table (index) for country" do
      
            before { visit country_gratuity_formulas_path(@country) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Gratuity Table: #{@country.country}") }
            it { should have_selector('h1', text: 'Gratuity Table') }
            it { should have_link('Add a line to the table', href: new_country_gratuity_formula_path(@country)) }
            it { should have_link('Back to main settings page', href: country_path(@country)) }
            it { should have_link('edit', href: edit_gratuity_formula_path(@country.gratuity_formulas.first)) }
            it { should have_link('del', href: gratuity_formula_path(@country.gratuity_formulas.first)) }
            it { should have_selector('#recent-adds') }
            it { should have_selector('.recent', text: "*") }
            it { should have_selector('.instruction', text: "EXPATRIATE LEAVER GRATUITIES") }
            it { should have_selector('.instruction', text: "For more details") } 
            it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
            it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
        
            describe "moving to the holiday edit link in the correct country" do
              before { click_link 'edit' }
          
              it { should have_selector('title', text: "Edit Gratuity Rule") }
              it { should have_selector('h1', text: @country.country) }
        
            end
        
            describe "deleting a gratuity line" do
        
              it "should be from the correct model" do
                expect { click_link('del') }.to change(GratuityFormula, :count).by(-1)            
              end
            end
          end
        
          describe "editing a gratuity rule" do
      
            let(:formula) { @country.gratuity_formulas.last }
            before { visit edit_gratuity_formula_path(formula) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Edit Gratuity Rule") }
            it { should have_selector('h1', text: 'Edit Gratuity Rule') }
            it { should have_link('Full gratuity table', href: country_gratuity_formulas_path(@country)) }
            it { should have_link('Country set-up page', href: country_path(@country)) }   
      
            describe "updating with valid data" do
          
              before do
                fill_in "resigns", with: 100
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Gratuity Table: #{@country.country}") }
              it { should have_selector('h1', text: 'Gratuity Table') }
              specify { formula.reload.resignation_percentage.should == 100}    
                 
            end
        
            describe "updating with invalid data" do
        
              before do
                fill_in "resigns", with: " "
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: 'Edit Gratuity Rule') }
              it { should have_content('error') }
              specify { formula.reload.resignation_percentage == 0 }
            end   
          end
        end
      end
    end
  end
  
  describe "when logged in as superuser - even if not a country administrator" do
  
    before do
      @superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
      sign_in @superuser 
    end
    
    describe "holidays controller" do
    
      describe "index of holidays for country" do
      
        before { visit country_holidays_path(@country) }
        
        it { should have_selector('h1', text: @country.country) }
        it { should have_selector('title', text: "National Holidays: #{@country.country}") }
        it { should have_selector('h1', text: 'National Holidays') }
        it { should have_link('Add a national holiday', href: new_country_holiday_path(@country)) }
        it { should have_link('Back to main settings page', href: country_path(@country)) }
        it { should have_link('edit', href: edit_holiday_path(@country.holidays.first)) }
        it { should have_link('delete', href: holiday_path(@country.holidays.first)) }
        it { should have_selector('#recent-adds') }
        it { should have_selector('.recent', text: "*") }
        it { should have_selector('.instruction', text: "Add the PUBLIC HOLIDAYS") }
        it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
        it { should_not have_selector('.instruction', text: "We're still looking for country administrators") }
        
        describe "moving to the holiday edit link in the correct country" do
          before { click_link 'edit' }
          
          it { should have_selector('title', text: "Edit National Holiday") }
          it { should have_selector('h1', text: @country.country) }
        
        end
        
        describe "deleting a national holiday" do
        
          it "should be from the correct model" do
            expect { click_link('del') }.to change(Holiday, :count).by(-1)            
          end
        end
      end
    end
  end
  
end
