#deals with InsuranceRates

require 'spec_helper'

describe "InsuranceCalculations" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "British")
    @currency = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
    @country = FactoryGirl.create(:country, country: "United Kingdom", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, insurance: true)
    @code_1 = @country.insurance_codes.create(insurance_code: "A", explanation: "Default employee")
    @code_2 = @country.insurance_codes.create(insurance_code: "B", explanation: "Pension age")
    @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
    @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
    @setting_3 = @country.insurance_settings.create(shortcode: "ST", name: "Secondary Threshold", weekly_milestone: 500, 
    										monthly_milestone: 2000, annual_milestone: 24000, effective_date: Date.today - 60.days)										
    @rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10.18, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
    @future_rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 11.0, created_by: 999999, updated_by: 999999,
    										effective: Date.today + 100.days, checked: true, source_employee: true)
    @historic_rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10.0, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 100.days, checked: true, source_employee: true)
    @employer_rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 5.18, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: false)	
    @employer_future_rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 6.0, created_by: 999999, updated_by: 999999,
    										effective: Date.today + 100.days, checked: true, source_employee: false)
    @employer_historic_rate = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 5.0, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 100.days, checked: true, source_employee: false)																				
    					    																				
  end
  
  describe "when not logged in" do
  
    describe "insurance rates for employees" do
    
      describe "current rates" do
      
        describe "when trying to enter a new insurance rate" do 
      
          before { visit new_country_insurance_rate_path(@country) }
      
          it "should render the home page" do
            page.should have_selector('.alert', text: 'Please sign in')
            page.should have_selector('h1', text: 'Sign in') 
          end
   
        end
       
        describe "when trying to access the current list of rates" do
    
          before { visit country_insurance_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      
        describe "when trying to change the insurance rates data" do
      
          describe "with a PUT request" do
            before { put insurance_rate_path(@rate) }
            specify { response.should redirect_to(root_path) }
          end
      
          describe "with a DELETE request" do
            before { delete insurance_rate_path(@rate) }
            specify { response.should redirect_to(root_path) }        
          end
        end
      end
      
      describe "future rates" do
      
        describe "when trying to access the future list of rates" do
    
          before { visit country_insurance_future_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      end
      
      describe "rates history" do
      
        describe "when trying to access the historic list of rates" do
    
          before { visit country_insurance_history_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      end
    end
    
    describe "employee rates for employers" do
    
      describe "current rates" do
       
        describe "when trying to access the current list of rates" do
    
          before { visit country_insurance_employer_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      end
      
      describe "future rates" do
        
        describe "when trying to access the future list of rates" do
    
          before { visit country_insurance_employer_future_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      end
      
      describe "rates history" do
        
        describe "when trying to access the historical list of rates" do
    
          before { visit country_insurance_employer_history_rates_path(@country) }
      
          it "should render the sign-in path" do
            page.should have_selector('.alert', text: 'sign in')
            page.should have_selector('h1', text: 'Sign in')
          end
        end
      end
    end
  end
  
  describe "when logged in as non-admin" do
    
    before do
      user = FactoryGirl.create(:user, name: "Non Admin", email: "nonadmin@example.com") 
      sign_in user
    end
    
    describe "insurance rates for employees" do
    
      describe "current rates" do
      
        describe "accessing the 'new' page" do
    
          before { visit new_country_insurance_rate_path(@country) }
               
          it "should render the root_path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
    
        describe "when trying to access the index" do
    
          before { visit country_insurance_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
    
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the InsuranceRate#destroy action" do
            before { delete insurance_rate_path(@rate) }
            specify { response.should redirect_to(root_path) }        
          end
    
        end
    
        describe "submitting a PUT request to the InsuranceRate#update action" do
          before { put insurance_rate_path(@rate) }
          specify { response.should redirect_to(root_path) }
        end
      end
      
      describe "future rates" do
        
        describe "when trying to access the index" do
    
          before { visit country_insurance_future_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
      end
      
      describe "rates history" do
      
        describe "when trying to access the index" do
    
          before { visit country_insurance_history_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
      end
    end
    
    describe "employee rates for employers" do
    
      describe "current rates" do
      
        describe "when trying to access the index" do
    
          before { visit country_insurance_employer_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
      end
      
      describe "future rates" do
      
        describe "when trying to access the index" do
    
          before { visit country_insurance_employer_future_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
      end
      
      describe "rates history" do
        
        describe "when trying to access the index" do
    
          before { visit country_insurance_employer_history_rates_path(@country) }
      
          it "should render the root-path" do
            page.should have_selector('.alert', text: 'You must be a HROomph admin')
            page.should have_selector('h2', text: 'Less HR - More Achievement.')
          end
        end
      end
    end
  end
  
  describe "when logged in as admin" do
  
    before do
      @admin = FactoryGirl.create(:admin, name: "An Admin", email: "anadmin@example.com")
      sign_in @admin
    end
  
    describe "when the Insurance field for Country is switched off" do
    
      before do
        @country.insurance = false
        @country.save
      end
      
      describe "when not a country admin" do
          
        describe "attempting to view list of current employee rates" do
            
          before { visit country_insurance_rates_path(@country) }
            
          it { should_not have_selector('h1', text: @country.country) }
          it { should_not have_selector('title', text: "Current Insurance Rates") }
          it { should have_selector('h1', text: 'Administrator Menu') }
          it { should have_selector('.alert', text: 'National Insurance is switched off') }
        end
        
        describe "attempting to view list of current employer rates" do
            
          before { visit country_insurance_employer_rates_path(@country) }
            
          it { should_not have_selector('h1', text: @country.country) }
          it { should_not have_selector('title', text: "Current Insurance Rates") }
          it { should have_selector('h1', text: 'Administrator Menu') }
          it { should have_selector('.alert', text: 'National Insurance is switched off') }
        end
          
        describe "attempting to open new page" do
          
          before { visit new_country_insurance_rate_path(@country) }  #reverts -default for non-country admin - same for edit, update
      
          it { should_not have_selector('title', text: 'New Insurance Rate') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
      end
      
      describe "when a country admin" do
      
        before { CountryAdmin.create(user_id: @admin.id, country_id: @country.id) }
          
        describe "trying to view the current rates for employees" do
          
          before { visit country_insurance_rates_path(@country) }
        
          it { should_not have_selector('h1', text: @country.country) }
          it { should_not have_selector('title', text: "Current Insurance Rates") }
          it { should have_selector('h1', text: 'Administrator Menu') }
          it { should have_selector('.alert', text: 'National Insurance is switched off') }
          
        end
        
        describe "trying to view the current rates for employers" do
          
          before { visit country_insurance_employer_rates_path(@country) }
        
          it { should_not have_selector('h1', text: @country.country) }
          it { should_not have_selector('title', text: "Current Insurance Rates") }
          it { should have_selector('h1', text: 'Administrator Menu') }
          it { should have_selector('.alert', text: 'National Insurance is switched off') }
          
        end
          
        describe "when trying to access the 'new' page" do
    
          before { visit new_country_insurance_rate_path(@country) }
      
          it { should_not have_selector('title', text: 'New Salary Rate') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
        
        describe "when trying to access the 'edit' page" do
    
          before { visit edit_insurance_rate_path(@rate) }
      
          it { should_not have_selector('title', text: 'Edit Salary Rate') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the InsuranceRate#destroy action" do
     
            before { delete insurance_rate_path(@rate) }
            specify { response.should redirect_to(user_path(@admin)) }        
          end
    
        end
    
        describe "submitting a PUT request to the InsuranceRate#update action" do
       
          before { put insurance_rate_path(@rate) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
      end  
    end
    
    describe "when the Insurance field for Country is switched on" do
    
      describe "when not a country admin" do
    
        describe "insurance rates for employees" do
    
          describe "current rates" do
      
            describe "index page" do
              before { visit country_insurance_rates_path(@country) }
              
              it { should_not have_link("Add a single rate", href: new_country_insurance_rate_path(@country)) }
              it { should have_link("Back to main insurance menu", href: insurance_menu_country_path(@country)) }
              it { should have_link("View full history", href: country_insurance_history_rates_path(@country)) }
              it { should have_link("View future rates", href: country_insurance_future_rates_path(@country)) }
        
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Current Insurance Rates - Employees") }
              it { should have_selector('h1', text: "Current Insurance Rates - Employees") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@rate)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should_not have_selector('.instruction', text: "in our video tutorial") } 
              it { should have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @rate.ceiling.shortcode) }
              it { should have_selector('#contribution', text: @rate.contribution.to_s) }
              it { should have_selector('.itemlist', text: "%") }
              it { should have_selector("li##{@rate.id}") }
              it { should_not have_selector("li##{@employer_rate.id}") }
              it { should_not have_selector('.itemlist', text: @country.currency.code) }
              it { should have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) } 
          
            end
            
            describe "attempting to open new page" do
          
              before { visit new_country_insurance_rate_path(@country) }  #reverts -default for non-country admin - same for edit, update
      
              it { should_not have_selector('title', text: 'New Insurance Rate') }
              it "should render the admin home page" do
                page.should have_selector('.alert', text: 'You must be a registered administrator')
                page.should have_selector('h1', text: 'Administrator Menu')
              end
            end
          end
      
          describe "future rates" do
      
            describe "index page" do
              before { visit country_insurance_future_rates_path(@country) }
            
              it { should_not have_link("Add a single rate", href: new_country_insurance_rate_path(@country)) }
              it { should have_link("Back to main insurance menu", href: insurance_menu_country_path(@country)) }
              it { should have_link("View rates history", href: country_insurance_history_rates_path(@country)) }
              it { should_not have_link("View future rates", href: country_insurance_future_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_rates_path(@country)) }         
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Future Insurance Rates - Employees") }
              it { should have_selector('h1', text: "Future Insurance Rates - Employees") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@future_rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@future_rate)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should_not have_selector('.instruction', text: "in our video tutorial") } 
              it { should have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @future_rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @future_rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @future_rate.ceiling.shortcode) }
              it { should have_selector("li##{@future_rate.id}") }
              it { should_not have_selector("li##{@employer_future_rate.id}") }
              it { should have_selector('.itemlist', text: "%") }
              it { should_not have_selector('.itemlist', text: @country.currency.code) }
              it { should have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) } 
            end
          end
      
          describe "rates history" do
          
            describe "index page" do
              before { visit country_insurance_history_rates_path(@country) }
            
              it { should_not have_link("Add a single rate", href: new_country_insurance_rate_path(@country)) }
              it { should have_link("Back to main insurance menu", href: insurance_menu_country_path(@country)) }
              it { should_not have_link("View rates history", href: country_insurance_history_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_rates_path(@country)) }
              
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance Rate History - Employees") }
              it { should have_selector('h1', text: "Insurance Rate History - Employees") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@rate)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should_not have_selector('.instruction', text: "in our video tutorial") } 
              it { should have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @future_rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @future_rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @future_rate.ceiling.shortcode) }
              it { should_not have_selector('.itemlist', text: @employer_rate.contribution.to_s) }
              it { should have_selector('.itemlist', text: "%") }
              it { should have_selector("li##{@rate.id}") }
              it { should_not have_selector("li##{@employer_rate.id}") }
              it { should have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) } 
            end
          end
        end
    
        describe "insurance rates for employers" do
    
          describe "current rates" do
          
            describe "index page" do
              before { visit country_insurance_employer_rates_path(@country) }
              
              it { should have_link("View full history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_selector('title', text: "Current Insurance Rates - Employers") }
              it { should have_selector('h1', text: "Current Insurance Rates - Employers") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@employer_rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@employer_rate)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should_not have_selector("li##{@rate.id}") }
              it { should have_selector("li##{@employer_rate.id}") }
              it { should have_selector('.itemlist', text: @employer_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_historic_rate.effective.strftime('%d %b %y')) } 
          
            end
          end
      
          describe "future rates" do
            
            describe "index page" do
              before { visit country_insurance_employer_future_rates_path(@country) }
              
              it { should have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
              it { should have_selector('title', text: "Future Insurance Rates - Employers") }
              it { should have_selector('h1', text: "Future Insurance Rates - Employers") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@employer_future_rate)) }
              it { should_not have_selector("li##{@future_rate.id}") }
              it { should have_selector("li##{@employer_future_rate.id}") }
              it { should have_selector('.itemlist', text: @employer_future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_historic_rate.effective.strftime('%d %b %y')) } 
          
            end
          end
      
          describe "rates history" do
      
            describe "index page" do
              before { visit country_insurance_employer_future_rates_path(@country) }
              
              it { should have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
              it { should have_selector('title', text: "Future Insurance Rates - Employers") }
              it { should have_selector('h1', text: "Future Insurance Rates - Employers") }
              it { should_not have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
              it { should_not have_link('del', href: insurance_rate_path(@employer_future_rate)) }
              it { should_not have_selector("li##{@future_rate.id}") }
              it { should have_selector("li##{@employer_future_rate.id}") }
              it { should have_selector('.itemlist', text: @employer_future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_historic_rate.effective.strftime('%d %b %y')) } 
          
            end
          end
        end
      end
    
      describe "and as a country admin" do
    
        before { CountryAdmin.create(user_id: @admin.id, country_id: @country.id) }
        
        describe "insurance rates for employees" do
    
          describe "current rates" do
      
            describe "index page" do
              before { visit country_insurance_rates_path(@country) }
        
              pending "Add a new set of rates"
              
              it { should have_link("Add a single rate", href: new_country_insurance_rate_path(@country)) }
              it { should have_link("Back to main insurance menu", href: insurance_menu_country_path(@country)) }
              it { should have_link("View full history", href: country_insurance_history_rates_path(@country)) }
              it { should have_link("View future rates", href: country_insurance_future_rates_path(@country)) }
              
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Current Insurance Rates - Employees") }
              it { should have_selector('h1', text: "Current Insurance Rates - Employees") }
              it { should have_link('edit', href: edit_insurance_rate_path(@rate)) }
              it { should have_link('del', href: insurance_rate_path(@rate)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @rate.ceiling.shortcode) }
              it { should have_selector('.itemlist', value: @rate.contribution) }
              it { should have_selector('.itemlist', text: "%") }
              it { should_not have_selector('.itemlist', text: @country.currency.code) }
              it { should have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) }
              it { should have_selector("li##{@rate.id}") } 
            end
            
            describe "restoring previous rate to current listing when latest rate is deleted" do
           
              before do
                delete insurance_rate_path(@rate)
                visit country_insurance_rates_path(@country)
              end
              
              it { should_not have_selector("li##{@rate.id}") }
              it { should have_selector("li##{@historic_rate.id}") }  
              
            end
            
            describe "adding a single new insurance rate" do
            
              before { visit new_country_insurance_rate_path(@country) }
              
              it { should have_selector('title', text: 'New Insurance Rate') }
              it { should have_selector('h1', text: 'New Insurance Rate') }
              it { should have_selector('h1', text: @country.country) }
              it { should have_link('Current National Insurance rates', href: country_insurance_rates_path(@country)) }
              it { should have_link("Main insurance menu", href: insurance_menu_country_path(@country)) }
              it { should_not have_selector('#insurance_rate_cancellation_date') }
              it { should have_selector('#insurance_rate_created_by', type: 'hidden', value: @admin.id) } 
              it { should have_selector('#insurance_rate_updated_by', type: 'hidden', value: @admin.id) }
      
              describe "with a new current rate" do
        
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "PT ( >GBP 800, effective", from: "Salary threshold"
                  #select "ST ( GBP 2000, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 10.75
                  fill_in "Effective date", with: Date.today - 60.days
                end
          
                it "should create a new insurance rate for the country" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Current Insurance Rates - Employees')
                  page.should have_selector('h1', text: @country.country)
                  page.should have_selector('.itemlist', value: 10.75)
                end 
              end
              
              describe "with a replacement rate in current records" do
              
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "LEL ( >GBP 400, effective", from: "Salary threshold"
                  #select "PT ( GBP 800, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 10.699
                  fill_in "Effective date", with: Date.today - 2.days
                  click_button "Create"
                  visit country_insurance_rates_path(@country)
                end
                
                it { should have_selector('.itemlist', value: 10.699) }
                it { should_not have_selector("li##{@rate.id}") }   #cf line 469 - old value is replaced
    
              end
              
              describe "when entering a rate for employers" do
                
                before do        
                  choose "or for Employers?"
                  select "A - Default employee", from: "Insurance code"
                  select "PT ( >GBP 800, effective", from: "Salary threshold"
                  #select "ST ( GBP 2000, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 5.35
                  fill_in "Effective date", with: Date.today - 60.days
                end
          
                it "should create a new employer insurance rate for the country" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Current Insurance Rates - Employers')
                  page.should have_selector('h1', text: @country.country)
                  page.should have_selector('.itemlist', value: 5.35)
                end 
              end
              
              describe "when entering a fixed rate instead of a percentage" do
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "PT ( >GBP 800, effective", from: "Salary threshold"
                  #select "ST ( GBP 2000, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 100
                  choose "or Value"
                  fill_in "Effective date", with: Date.today - 60.days
                end
          
                it "should drop the percentage sign and add the local currency" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Current Insurance Rates - Employees')
                  page.should have_selector('h1', text: @country.country)
                  page.should have_selector('.itemlist', text: "GBP")
                end 
              end
              
              describe "when entering a rebate" do
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "PT ( >GBP 800, effective", from: "Salary threshold"
                  #select "ST ( GBP 2000, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 1
                  choose "or Rebate"
                  fill_in "Effective date", with: Date.today - 60.days
                end
          
                it "should drop the percentage sign and add the local currency" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Current Insurance Rates - Employees')
                  page.should have_selector('h1', text: @country.country)
                  page.should have_selector('.itemlist', text: "(")
                 
                end 
              end
            
              describe "with valid future data" do
            
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "PT ( >GBP 800, effective", from: "Salary threshold"
                  #select "ST ( GBP 2000, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 11.75
                  fill_in "Effective date", with: Date.today + 60.days
                end
          
                it "should create a new insurance rate for the country but redirect to Future" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Future Insurance Rates - Employees')
                  page.should have_selector('#recent-adds')
                  page.should have_selector('.recent', text: "*")
                  page.should_not have_selector('#recent-add-checks')
                  page.should_not have_selector('.recent', text: "+")
                  page.should have_selector('#change-note', text: "Stats include changes")
                end 
            
              end
            
              describe "with valid historic data" do
            
                before do        
                  select "A - Default employee", from: "Insurance code"
                  select "LEL ( >GBP 400, effective", from: "Salary threshold"
                  #select "PT ( GBP 800, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 9.5
                  fill_in "Effective date", with: Date.today - 500.days
                end
          
                it "should create a new insurance rate for the country but redirect to History" do
                  expect { click_button "Create" }.to change(@country.insurance_rates, :count).by(1)
                  page.should have_selector('h1', text: 'Insurance Rate History - Employees')
                  page.should have_selector('#recent-adds')
                  page.should have_selector('.recent', text: "*")
                  page.should_not have_selector('#recent-add-checks')
                  page.should_not have_selector('.recent', text: "+")
                  page.should_not have_selector('#change-note', text: "Changes are best seen")
                end 
            
              end
        
              describe "with invalid data" do
           
                before do
                  select "A - Default employee", from: "Insurance code"
                  #select "LEL ( >GBP 400, effective", from: "Salary threshold"
                  #select "PT ( GBP 800, effective", from: "Salary ceiling"
                  fill_in "Contribution", with: 9.5
                  fill_in "Effective date", with: Date.today - 500.days
                end
          
                it "should not create a new insurance rate for the country" do
                  expect { click_button "Create" }.not_to change(@country.insurance_rates, :count) # not working, no error because
                                                               #missing contribution new
                  page.should have_selector('h1', text: 'New Insurance Rate')
                  page.should have_selector('h1', text: @country.country)
                  page.should have_content('error')    
                end
              end
            end
          end
      
          describe "future rates" do
      
            describe "index page" do
              before { visit country_insurance_future_rates_path(@country) }
            
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Future Insurance Rates - Employees") }
              it { should have_selector('h1', text: "Future Insurance Rates - Employees") }
              it { should have_link('edit', href: edit_insurance_rate_path(@future_rate)) }
              it { should have_link('del', href: insurance_rate_path(@future_rate)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @future_rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @future_rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @future_rate.ceiling.shortcode) }
              it { should have_selector('.itemlist', value: @future_rate.contribution) }
              it { should have_selector('.itemlist', text: "%") }
              it { should_not have_selector('.itemlist', text: @country.currency.code) }
              it { should have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) } 
            end

          end
      
          describe "rates history" do
      
            describe "index page" do
              before { visit country_insurance_history_rates_path(@country) }
            
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance Rate History - Employees") }
              it { should have_selector('h1', text: "Insurance Rate History - Employees") }
              it { should have_link('edit', href: edit_insurance_rate_path(@rate)) }
              it { should have_link('del', href: insurance_rate_path(@rate)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "INSURANCE RATES") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector('.itemlist', text: @future_rate.insurance_code.insurance_code) }
              it { should have_selector('.itemlist', text: @future_rate.threshold.shortcode) }
              it { should have_selector('.itemlist', text: @future_rate.ceiling.shortcode) }
              it { should have_selector('.itemlist', value: @future_rate.contribution) }
              it { should have_selector('.itemlist', text: "%") }
              it { should_not have_selector('.itemlist', text: @country.currency.code) }
              it { should have_selector('.itemlist', text: @future_rate.effective.strftime('%d %b %y')) }
              it { should have_selector('.itemlist', text: @rate.effective.strftime('%d %b %y')) }
              it { should have_selector('.itemlist', text: @historic_rate.effective.strftime('%d %b %y')) } 
            end
          end
        end
    
        describe "insurance rates for employers" do
    
          describe "current rates" do
          
            describe "index page" do
              before { visit country_insurance_employer_rates_path(@country) }
              
              it { should have_link("View full history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_selector('title', text: "Current Insurance Rates - Employers") }
              it { should have_selector('h1', text: "Current Insurance Rates - Employers") }
              it { should have_link('edit', href: edit_insurance_rate_path(@employer_rate)) }
              it { should have_link('del', href: insurance_rate_path(@employer_rate)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should_not have_selector("li##{@rate.id}") }
              it { should have_selector("li##{@employer_rate.id}") }
              it { should have_selector('.itemlist', text: @employer_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_historic_rate.effective.strftime('%d %b %y')) } 
          
            end
          end
          
          describe "restoring previous rate to current listing when latest rate is deleted" do
           
            before do
              delete insurance_rate_path(@employer_rate)
              visit country_insurance_employer_rates_path(@country)
            end
              
            it { should_not have_selector("li##{@employer_rate.id}") }
            it { should have_selector("li##{@employer_historic_rate.id}") }  
              
          end
      
          describe "future rates" do
            
            describe "index page" do
              before { visit country_insurance_employer_future_rates_path(@country) }
              
              it { should have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
              it { should have_selector('title', text: "Future Insurance Rates - Employers") }
              it { should have_selector('h1', text: "Future Insurance Rates - Employers") }
              it { should have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
              it { should have_link('del', href: insurance_rate_path(@employer_future_rate)) }
              it { should_not have_selector("li##{@future_rate.id}") }
              it { should have_selector("li##{@employer_future_rate.id}") }
              it { should have_selector('.itemlist', text: @employer_future_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_rate.effective.strftime('%d %b %y')) }
              it { should_not have_selector('.itemlist', text: @employer_historic_rate.effective.strftime('%d %b %y')) } 
          
            end
          end
      
          describe "rates history" do
      
            describe "index page" do
              before { visit country_insurance_employer_history_rates_path(@country) }
              
              it { should_not have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
              it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
              it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
              it { should have_selector('title', text: "Insurance Rate History - Employers") }
              it { should have_selector('h1', text: "Insurance Rate History - Employers") }
              it { should have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
              it { should have_link('del', href: insurance_rate_path(@employer_future_rate)) }
              it { should_not have_selector("li##{@future_rate.id}") }
              it { should have_selector("li##{@employer_future_rate.id}") }
              it { should have_selector("li##{@employer_rate.id}") }
              it { should have_selector("li##{@employer_historic_rate.id}") }
            end
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
    
    describe "when the Insurance field for Country is switched off" do
    
      before do
        @country.insurance = false
        @country.save
      end
      
      describe "attempting to view list of current employee rates" do
            
        before { visit country_insurance_rates_path(@country) }
            
        it { should_not have_selector('h1', text: @country.country) }
        it { should_not have_selector('title', text: "Current Insurance Rates") }
        it { should have_selector('h1', text: 'Administrator Menu') }
        it { should have_selector('.alert', text: 'National Insurance is switched off') }
      end
        
      describe "attempting to view list of current employer rates" do
            
        before { visit country_insurance_employer_rates_path(@country) }
            
        it { should_not have_selector('h1', text: @country.country) }
        it { should_not have_selector('title', text: "Current Insurance Rates") }
        it { should have_selector('h1', text: 'Administrator Menu') }
        it { should have_selector('.alert', text: 'National Insurance is switched off') }
      end
          
      describe "attempting to open new page" do
          
        before { visit new_country_insurance_rate_path(@country) }  #same for edit, update
      
        it { should_not have_selector('title', text: 'New Insurance Rate') }
        it "should render the admin home page" do
          page.should have_selector('h1', text: 'Administrator Menu')
          page.should have_selector('.alert', text: 'National Insurance is switched off')
        end
      end
      
      describe "when trying to access the 'edit' page" do
    
        before { visit edit_insurance_rate_path(@rate) }
      
        it { should_not have_selector('title', text: 'Edit Salary Rate') }
        it "should render the admin home page" do
          page.should have_selector('.alert', text: "National Insurance is switched off for this country")
          page.should have_selector('h1', text: 'Administrator Menu')
        end
      end
      
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceRate#destroy action" do
     
          before { delete insurance_rate_path(@rate) }
          specify { response.should redirect_to(user_path(@superuser)) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceRate#update action" do
       
        before { put insurance_rate_path(@rate) }
        specify { response.should redirect_to(user_path(@superuser)) }
      end
     
    end
    
    describe "when the Insurance field for Country is switched on" do
    
      describe "insurance rates for employees" do
      
        describe "current rates" do
      
          describe "entering a new code" do
        
            before { visit new_country_insurance_rate_path(@country) }
            it { should have_selector('input#insurance_rate_checked', value: 1) }
          
            describe "automatic checking of record entered by superuser" do
              before do        
                select "A - Default employee", from: "Insurance code"
                select "LEL ( >GBP 400, effective", from: "Salary threshold"
                select "PT ( GBP 800, effective", from: "Salary ceiling"
                fill_in "Contribution", with: 10.699
                fill_in "Effective date", with: Date.today - 2.days
                click_button "Create"
                visit country_insurance_rates_path(@country)
              end
                
              it "should create the new record and push code it replaces into history" do
            
                page.should have_selector('.itemlist', value: 10.699)
                page.should_not have_selector("li##{@rate.id}")
                page.should have_selector('h1', text: 'Current Insurance Rates - Employees')
                page.should have_selector('h1', text: @country.country)
                page.should_not have_selector('.recent', text: "+") 
              end
            end
          end
        
          describe "checking a new entry via Edit" do
         
            before do 
              @rate.toggle!(:checked)
              visit edit_insurance_rate_path(@rate)
            end
          
            it { should have_selector('input#insurance_rate_checked') }
            it { should have_selector('#update-date', text: "Added") }
          
            describe "not changing updated and checked status when superuser edits the code" do
        
              before do
                fill_in "Contribution", with: 10.999
                #fill_in "Effective date", with: Date.today + 2.days
                click_button "Save changes"
              end
          
              specify { @rate.reload.checked == true }
              specify { @rate.reload.updated_by != @superuser.id }
            end
          end
                   
          describe "index page" do
            before do
              @rate.toggle!(:checked)
              visit country_insurance_rates_path(@country) 
            end
        
            pending "Add a new set of rates"
              
            it { should have_link("Add a single rate", href: new_country_insurance_rate_path(@country)) }
            it { should have_link("Back to main insurance menu", href: insurance_menu_country_path(@country)) }
            it { should have_link("View full history", href: country_insurance_history_rates_path(@country)) }
            it { should have_link("View future rates", href: country_insurance_future_rates_path(@country)) }
              
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Current Insurance Rates - Employees") }
            it { should have_link('edit', href: edit_insurance_rate_path(@rate)) }
            it { should have_link('del', href: insurance_rate_path(@rate)) }
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
            it { should have_selector('.instruction', text: "INSURANCE RATES") }
            it { should have_selector('.instruction', text: "in our video tutorial") } 
            it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
            it { should have_selector('.itemlist', text: @rate.insurance_code.insurance_code) }
            it { should have_selector("li##{@rate.id}") }
            it { should_not have_selector("li##{@future_rate.id}") } 
            it { should_not have_selector("li##{@historic_rate.id}") } 
          end
          
          
        end
      
        describe "future rates" do
          
          describe "index page" do
            before { visit country_insurance_future_rates_path(@country) }
            
            it { should have_selector('title', text: "Future Insurance Rates - Employees") }
            it { should have_selector('h1', text: "Future Insurance Rates - Employees") }
            it { should have_link('edit', href: edit_insurance_rate_path(@future_rate)) }
            it { should have_link('del', href: insurance_rate_path(@future_rate)) }
            it { should_not have_selector("li##{@rate.id}") }
            it { should have_selector("li##{@future_rate.id}") } 
            it { should_not have_selector("li##{@historic_rate.id}") } 
          end
        end
      
        describe "rates history" do
        
          describe "index page" do
            before { visit country_insurance_history_rates_path(@country) }
            
            it { should have_selector('title', text: "Insurance Rate History - Employees") }
            it { should have_selector('h1', text: "Insurance Rate History - Employees") }
            it { should have_link('edit', href: edit_insurance_rate_path(@rate)) }
            it { should have_link('del', href: insurance_rate_path(@rate)) }
            it { should have_selector("li##{@rate.id}") }
            it { should have_selector("li##{@future_rate.id}") } 
            it { should have_selector("li##{@historic_rate.id}") } 
          end
      
        end
      end
    
      describe "employee rates for employers" do
    
        describe "current rates" do
          
          describe "index page" do
            
            before do
              @employer_rate.toggle!(:checked)
              visit country_insurance_employer_rates_path(@country)
            end  
            
            it { should have_link("View full history", href: country_insurance_employer_history_rates_path(@country)) }
            it { should have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
            it { should have_selector('title', text: "Current Insurance Rates - Employers") }
            it { should have_selector('h1', text: "Current Insurance Rates - Employers") }
            it { should have_link('edit', href: edit_insurance_rate_path(@employer_rate)) }
            it { should have_link('del', href: insurance_rate_path(@employer_rate)) }
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
            it { should_not have_selector("li##{@rate.id}") }
            it { should have_selector("li##{@employer_rate.id}") }
            it { should_not have_selector("li##{@employer_future_rate.id}") } 
            it { should_not have_selector("li##{@employer_historic_rate.id}") } 
          end
        end
      
        describe "future rates" do
          
          describe "index page" do
            before { visit country_insurance_employer_future_rates_path(@country) }
              
            it { should have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
            it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
            it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
            it { should have_selector('title', text: "Future Insurance Rates - Employers") }
            it { should have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
            it { should have_link('del', href: insurance_rate_path(@employer_future_rate)) }
            it { should_not have_selector("li##{@future_rate.id}") }
            it { should have_selector("li##{@employer_future_rate.id}") }
            it { should_not have_selector("li##{@employer_rate.id}") }
            it { should_not have_selector("li##{@employer_historic_rate.id}") }
          end
        end
      
        describe "rates history" do
        
          describe "index page" do
            before { visit country_insurance_employer_history_rates_path(@country) }
              
            it { should_not have_link("View rates history", href: country_insurance_employer_history_rates_path(@country)) }
            it { should_not have_link("View future rates", href: country_insurance_employer_future_rates_path(@country)) }
            it { should have_link("View current rates instead", href: country_insurance_employer_rates_path(@country)) }
            it { should have_selector('title', text: "Insurance Rate History - Employers") }
            it { should have_link('edit', href: edit_insurance_rate_path(@employer_future_rate)) }
            it { should have_link('del', href: insurance_rate_path(@employer_future_rate)) }
            it { should_not have_selector("li##{@future_rate.id}") }
            it { should have_selector("li##{@employer_future_rate.id}") }
            it { should have_selector("li##{@employer_rate.id}") }
            it { should have_selector("li##{@employer_historic_rate.id}") }
          end
        end
      end
    end
  end
end
