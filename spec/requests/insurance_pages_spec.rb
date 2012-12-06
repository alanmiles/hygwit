require 'spec_helper'

describe "InsurancePages" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "British")
    @currency = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
    @country = FactoryGirl.create(:country, country: "United Kingdom", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, insurance: true)
    @setting = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 107, 
    										monthly_milestone: 464, annual_milestone: 5564, effective_date: Date.today-60.days)
    @setting_old = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 425, annual_milestone: 5100, effective_date: Date.today-120.days)
    @setting_new = @country.insurance_settings.create(shortcode: "AEL", name: "Another Earnings Limit", weekly_milestone: 110, 
    										monthly_milestone: 575, annual_milestone: 6900, effective_date: Date.today+60.days)
    @setting_2 = @country.insurance_settings.create(shortcode: "UEL", name: "Upper Earnings Limit", weekly_milestone: 2000, 
    										monthly_milestone: 8500, annual_milestone: 102000, effective_date: Date.today-130.days) 
    @setting_cancelled_past = @country.insurance_settings.create(shortcode: "NUP", name: "Not Used Past", weekly_milestone: 150, 
    										monthly_milestone: 625, annual_milestone: 7500, effective_date: Date.today-130.days, 
    										cancellation_date: Date.today-30.days)
    @setting_cancelled_future = @country.insurance_settings.create(shortcode: "NUF", name: "Not Used Future", weekly_milestone: 250, 
    										monthly_milestone: 1025, annual_milestone: 12300, effective_date: Date.today-130.days, 
    										cancellation_date: Date.today + 30.days)
    @code = @country.insurance_codes.create(insurance_code: "A", explanation: "Standard employee", checked: true)	
    @old_code	= @country.insurance_codes.create(insurance_code: "Z", explanation: "Cancelled code", 
    										cancelled: Date.today - 30, checked: true)								    																				
  end
  
  describe "when not logged in" do
  
    describe "Insurance Settings controller" do
    
      describe "when trying to enter a new salary threshold" do 
      
        before { visit new_country_insurance_setting_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
   
      end
       
      describe "when trying to access the index (Salary threshold table)" do
    
        before { visit country_insurance_settings_path(@country) }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the insurance settings data" do
      
        describe "with a PUT request" do
          before { put insurance_setting_path(@setting) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete insurance_setting_path(@setting) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "Insurance Codes controller" do
    
      describe "when trying to enter a new code" do 
      
        before { visit new_country_insurance_code_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
   
      end
       
      describe "when trying to access the index (Salary code table)" do
    
        before { visit country_insurance_codes_path(@country) }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the insurance codes data" do
      
        describe "with a PUT request" do
          before { put insurance_code_path(@code) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete insurance_code_path(@code) }
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
  
    describe "Insurance Settings controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_insurance_setting_path(@country) }
      
        it { should_not have_selector('title', text: 'New Salary Threshold') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_insurance_settings_path(@country) }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceSetting#destroy action" do
          before { delete insurance_setting_path(@setting) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceSetting#update action" do
        before { put insurance_setting_path(@setting) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "Insurance Codes controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_insurance_code_path(@country) }
      
        it { should_not have_selector('title', text: 'New Insurance Code') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_insurance_codes_path(@country) }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Less HR - More Achievement.')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceCodes#destroy action" do
          before { delete insurance_code_path(@code) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceCodes#update action" do
        before { put insurance_code_path(@code) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
  end
  
  describe "when logged in as admin" do
  
    before do
      @admin = FactoryGirl.create(:admin, name: "An Admin", email: "anadmin@example.com")
      sign_in @admin
    end
    
    describe "when the Insurance field for Country is switched on" do
    
      describe "show insurance menu page" do
    
        before { visit insurance_menu_country_path(@country) }
      
        it { should have_selector('title', text: 'National Insurance Menu') }
        it { should have_selector('h1', text: 'National Insurance Menu') }
        it { should have_selector('h1', text: @country.country) }
        it { should have_link('Salary Thresholds', href: country_insurance_settings_path(@country)) }
        it { should have_link('Insurance Codes', href: country_insurance_codes_path(@country)) }
        it { should have_link("main settings menu - #{@country.country}", href: country_path(@country)) }
        it { should have_selector('.instruction', text: "HR2.0's universal National Insurance tool") }
        it { should_not have_selector(".standout", text: " National Insurance does not apply") }
        it { should have_link("Choose another country", href: countries_path) }
      end
      
    end
    
    describe "when the Insurance field for Country is switched off" do
    
      before do
        @country.insurance = false
        @country.save
      end
      
      describe "show adjusted insurance menu page" do
        
        before { visit insurance_menu_country_path(@country) }
      
        it { should_not have_link('Salary thresholds', href: country_insurance_settings_path(@country)) }
        it { should have_link("main settings menu - #{@country.country}", href: country_path(@country)) }
        it { should have_selector('.instruction', text: "HR2.0's universal National Insurance tool") }
        it { should_not have_selector('.instruction', 'Set up the insurance rules') }
        it { should have_selector(".standout", text: "National Insurance does not apply") }
        it { should have_link("Choose another country", href: countries_path) }
      end
    
    end
    
    describe "when user is not a country admin" do
      
      describe "landing on the insurance menu page" do
        
        before { visit insurance_menu_country_path(@country) }
        it { should_not have_selector('.instruction', text: "Set up the insurance rules") }
        
      end
      
      describe "Insurance Settings controller" do
      
        describe "insurance settings index (Salary Thresholds table)" do
      
          before { visit country_insurance_settings_path(@country) }
        
          it { should_not have_selector('.standout', text: "WARNING") }
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
          it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
          it { should_not have_link('edit', href: edit_insurance_setting_path(@country.insurance_settings.first)) }
          it { should_not have_link('del', href: insurance_setting_path(@country.insurance_settings.first)) }
          it { should_not have_selector('#recent-adds') }
          it { should_not have_selector('.recent', text: "*") }
          it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
          it { should_not have_selector('.instruction', text: "in our video tutorial") } 
          it { should have_selector('.instruction', text: "You're not registered as an administrator") }
          it { should have_selector('.itemlist', text: "464") }
          it { should have_selector('.itemlist', text: "8500") }
          it { should_not have_selector('.itemlist', text: "425") }  #historical threshold @setting_old
          it { should_not have_selector('.itemlist', text: "575") }  #future threshold @setting_new 
          it { should_not have_selector('.itemlist', text: "Not Used Past") }
          it { should have_selector('.itemlist', text: "Not Used Future") }
        end
        
        describe "when trying to access the 'new' page" do
    
          before { visit new_country_insurance_setting_path(@country) }
      
          it { should_not have_selector('title', text: 'New Salary Threshold') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
        
        describe "when trying to access the 'edit' page" do
    
          before { visit edit_insurance_setting_path(@setting) }
      
          it { should_not have_selector('title', text: 'Edit Salary Threshold') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the InsuranceSettings#destroy action" do
     
            before { delete insurance_setting_path(@setting) }
            specify { response.should redirect_to(user_path(@admin)) }        
          end
    
        end
    
        describe "submitting a PUT request to the InsuranceSettings#update action" do
       
          before { put insurance_setting_path(@setting) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
    
      end
      
      describe "Insurance Codes controller" do
      
        describe "insurance codes index (Salary Codes table)" do
      
          before { visit country_insurance_codes_path(@country) }
        
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "Insurance Codes") }
          it { should have_selector('h1', text: 'Insurance Codes') }
          it { should_not have_link('edit', href: edit_insurance_setting_path(@code)) }
          it { should_not have_link('del', href: insurance_setting_path(@code)) }
          it { should_not have_selector('#recent-adds') }
          it { should_not have_selector('.recent', text: "*") }
          it { should have_selector('.instruction', text: "INSURANCE CODES") }
          it { should_not have_selector('.instruction', text: "in our video tutorial") } 
          it { should have_selector('.instruction', text: "You're not registered as an administrator") }
          it { should have_selector('.itemlist', text: @code.insurance_code) }
          it { should have_selector('.itemlist', text: @code.explanation) }
          it { should have_selector('.itemlist', text: @old_code.cancelled.strftime('%d %b %Y')) }
        end
        
        describe "when trying to access the 'new' page" do
    
          before { visit new_country_insurance_code_path(@country) }
      
          it { should_not have_selector('title', text: 'New Insurance Code') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
        
        describe "when trying to access the 'edit' page" do
    
          before { visit edit_insurance_code_path(@code) }
      
          it { should_not have_selector('title', text: 'Edit Insurance Code') }
          it "should render the admin home page" do
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "when trying to delete" do
    
          describe "submitting a DELETE request to the InsuranceCode#destroy action" do
     
            before { delete insurance_code_path(@code) }
            specify { response.should redirect_to(user_path(@admin)) }        
          end
    
        end
    
        describe "submitting a PUT request to the InsuranceCode#update action" do
       
          before { put insurance_code_path(@code) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
    
      end
    
    end
    
    describe "when user is a country admin" do
    
      before { CountryAdmin.create(user_id: @admin.id, country_id: @country.id) }
      
      describe "Insurance Settings controller" do
    
        describe "when the country's Insurance control is switched on" do 
        
          describe "landing on the insurance menu page" do
        
            before { visit insurance_menu_country_path(@country) }
            it { should have_selector('.instruction', text: "Set up the insurance rules") }
            
        
          end
        
          describe "add a new salary threshold line for the country" do
      
            before { visit new_country_insurance_setting_path(@country.id) }
        
            it { should have_selector('title', text: 'New Salary Threshold') }
            it { should have_selector('h1', text: 'New Salary Threshold') }
            it { should have_selector('h1', text: @country.country) }
            it { should have_link('Salary thresholds table', href: country_insurance_settings_path(@country)) }
            it { should have_link("Main insurance menu", href: insurance_menu_country_path(@country)) }
            it { should_not have_selector('#insurance_setting_cancellation_date') }
            it { should have_selector('.line-space', text: "No blanks") }
      
            describe "with valid current data" do
        
              before do        
                fill_in "Code", with: "ST"
                fill_in "Description", with: "Secondary Threshold"
                fill_in "Weekly milestone", with: 144
                fill_in "Monthly milestone", with: 624
                fill_in "Annual milestone", with: 7488
                fill_in "Effective date", with: Date.today - 60.days
              end
          
              it "should create a new insurance setting for the country" do
                expect { click_button "Create" }.to change(InsuranceSetting, :count).by(1)
                page.should have_selector('h1', text: 'Insurance: Current Salary Thresholds')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: 'Insurance: Current Salary Thresholds')
              end 
            end
            
            describe "with valid future data" do
            
              before do        
                fill_in "Code", with: "ST"
                fill_in "Description", with: "Secondary Threshold"
                fill_in "Weekly milestone", with: 144
                fill_in "Monthly milestone", with: 624
                fill_in "Annual milestone", with: 7488
                fill_in "Effective date", with: Date.today + 60.days
              end
          
              it "should create a new insurance setting for the country but redirect to Future" do
                expect { click_button "Create" }.to change(InsuranceSetting, :count).by(1)
                page.should have_selector('h1', text: 'Insurance: Future Salary Thresholds')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: 'Insurance: Future Salary Thresholds')
              end 
            
            end
            
            describe "with valid historic data" do
            
              before do        
                fill_in "Code", with: "UEL"   #UEL record already exists formed today - 130 days
                fill_in "Description", with: "Upper Earnings Limit"
                fill_in "Weekly milestone", with: 1900
                fill_in "Monthly milestone", with: 7800
                fill_in "Annual milestone", with: 93600
                fill_in "Effective date", with: Date.today - 500.days
              end
          
              it "should create a new insurance setting for the country but redirect to History" do
                expect { click_button "Create" }.to change(InsuranceSetting, :count).by(1)
                page.should have_selector('h1', text: 'Insurance: Salary Threshold History')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: 'Insurance: Salary Threshold History')
              end 
            
            end
        
            describe "with invalid data" do
           
              before do
                fill_in "Code", with: "  "
              end
          
              it "should not create a new insurance setting for the country" do
                expect { click_button "Create" }.not_to change(InsuranceSetting, :count)
                page.should have_selector('h1', text: 'New Salary Threshold')
                page.should have_selector('h1', text: @country.country)
                page.should have_content('error')    
              end
            end
            
            describe "with a code that has previously been cancelled" do
            
              before do        
                fill_in "Code", with: "NUP"   #already cancelled
                fill_in "Description", with: "Not Used Past"
                fill_in "Weekly milestone", with: 160
                fill_in "Monthly milestone", with: 660
                fill_in "Annual milestone", with: 7920
                fill_in "Effective date", with: Date.today
              end
              
              it "should not create a new insurance setting for the country" do
                expect { click_button "Create" }.not_to change(InsuranceSetting, :count)
                page.should have_selector('h1', text: 'New Salary Threshold')
                page.should have_selector('h1', text: @country.country)
                page.should have_content('error')    
              end
            end
          end
          
          describe "Insurance Settings table (index - salary thresholds) for country" do
      
            before { visit country_insurance_settings_path(@country) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
            it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
            it { should have_link('Add a line to the table', href: new_country_insurance_setting_path(@country)) }
            it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
            it { should have_link('edit', href: edit_insurance_setting_path(@country.insurance_settings.first)) }
            it { should have_link('del', href: insurance_setting_path(@country.insurance_settings.first)) }
            it { should have_selector('#recent-adds') }
            it { should have_selector('.recent', text: "*") }
            it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
            it { should have_selector('.instruction', text: "in our video tutorial") } 
            it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
            it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
            it { should have_selector('.standout', text: "WARNING") }
            it { should_not have_selector('.itemlist', text: "Not Used Past") }
            it { should have_selector('.itemlist', text: "Not Used Future") }
        
            describe "moving to the insurance settings edit link in the correct country" do
              before { click_link 'edit' }
          
              it { should have_selector('title', text: "Edit Salary Threshold") }
              it { should have_selector('h1', text: @country.country) }
        
            end
        
            describe "deleting a salary thresholds line" do
        
              it "should be from the correct model" do
                expect { click_link('del') }.to change(InsuranceSetting, :count).by(-1)            
              end
            end
          end
          
          describe "editing a salary thresholds line" do
          
            let(:setting) { @setting_2 }
            before { visit edit_insurance_setting_path(setting) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Edit Salary Threshold") }
            it { should have_selector('h1', text: 'Edit Salary Threshold') }
            it { should have_link('Salary thresholds table', href: country_insurance_settings_path(@country)) }
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should have_selector('#insurance_setting_cancellation_date') }
            it { should_not have_selector('.line-space', text: "No blanks") }
      
            describe "updating with valid data" do
          
              before do
                fill_in "Code", with: 'UAL'
                fill_in "Description", with: 'Upper Accrual Limit'
                fill_in "Weekly milestone", with: 1080
                fill_in "Monthly milestone", with: 4000
                fill_in "Annual milestone", with: 48000
                fill_in "Effective date", with: (Date.today - 10.days)
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
              it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
              specify { setting.reload.name.should == "Upper Accrual Limit" }    
                 
            end
            
            describe "cancelling a salary threshold category" do
            
              describe "cancellation date has already passed" do
              
                before do
                  fill_in "Cancellation date", with: (Date.today - 1.day)
                  click_button "Save changes"
                end
                
                it { should have_selector('h1', text: @country.country) }
                it { should have_selector('h1', text: 'Insurance: Salary Threshold History') }
                it { should have_selector('div.alert.alert-success', text: "It will still be displayed in the History list") }
                it { should have_selector('.itemlist', text: "CANCELLED #{date_display(Date.today - 1.day)}") }
              end
              
              describe "cancellation date is in the future" do
                
                before do
                  fill_in "Cancellation date", with: (Date.today + 10.days)
                  click_button "Save changes"
                end
                
                it { should have_selector('h1', text: @country.country) }
                it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
                it { should have_selector('div.alert.alert-success', text: "but for a date in the future") }
                it { should have_selector('.itemlist', text: "CANCELLED from #{date_display(Date.today + 10.days)}") }
              end
            
            end
        
            describe "updating with invalid data" do
        
              before do
                fill_in "Code", with: " "
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: 'Edit Salary Threshold') }
              it { should have_content('error') }
              specify { setting.reload.name.should_not == 0 }
            end   
          end
          
          describe "editing a threshold setting that has already been cancelled" do
        
            let(:setting) { @setting_cancelled_past }
            before { visit edit_insurance_setting_path(setting) }
            
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should have_selector('#insurance_setting_cancellation_date') }
            it { should_not have_selector('.line-space', text: "No blanks") }
        
            describe "cancel the cancellation date" do        
              
              before do
                fill_in "Cancellation date", with: nil
                click_button "Save changes"
              end
                
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
              it { should have_selector('.itemlist', text: setting.shortcode) }
              it { should_not have_selector('.itemlist', text: "CANCELLED #{date_display(Date.today - 30.days)}") }
            end
          end
          
          describe "trying to set a cancellation date when a future setting for the code already exists" do
          
            before do
              @setting_new_insert = @country.insurance_settings.create(shortcode: "AEL", name: "Another Earnings Limit", 
                    weekly_milestone: 100, monthly_milestone: 450, annual_milestone: 5400, effective_date: Date.today-60.days)
              visit edit_insurance_setting_path(@setting_new_insert)
            end
          
            describe "set cancellation_date" do
              
              before do
                fill_in "Cancellation date", with: Date.today
                click_button "Save changes"
              end
              
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: 'Edit Salary Threshold') }
              it { should have_content('error') }
            end
          end
          
          
          describe "editing a threshold setting that has not been cancelled but isn't in current list" do
          
            let(:setting) { @setting_old }
            before { visit edit_insurance_setting_path(setting) }
          
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should_not have_selector('#insurance_setting_cancellation_date') }
          end
          
          describe "editing a threshold setting that's in the future list" do
            
            let(:setting) { @setting_new }
            before { visit edit_insurance_setting_path(setting) }
          
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should_not have_selector('#insurance_setting_cancellation_date') }
          
          end
        end
        
        describe "when the country's Insurance control is switched off" do
          
          before do
            @country.insurance = false
            @country.save
          end
          
          describe "landing on the insurance menu page" do
          
            before { visit insurance_menu_country_path(@country) }
            it { should have_selector('.standout', text: "switched off") }
            it { should have_link("Edit country settings", href: edit_country_path(@country)) }
          end
          
          describe "trying to open the index page" do
          
            before { visit country_insurance_settings_path(@country) }
        
            it { should_not have_selector('h1', text: @country.country) }
            it { should_not have_selector('title', text: "Insurance: Current Salary Thresholds") }
            it { should have_selector('h1', text: 'Administrator Menu') }
          
          end
          
          describe "when trying to access the 'new' page" do
    
            before { visit new_country_insurance_setting_path(@country) }
      
            it { should_not have_selector('title', text: 'New Salary Threshold') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: "National Insurance is switched off for this country")
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
        
          describe "when trying to access the 'edit' page" do
    
            before { visit edit_insurance_setting_path(@setting) }
      
            it { should_not have_selector('title', text: 'Edit Salary Threshold') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: "National Insurance is switched off for this country")
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
      
          describe "when trying to delete" do
    
            describe "submitting a DELETE request to the InsuranceSetting#destroy action" do
     
              before { delete insurance_setting_path(@setting) }
              specify { response.should redirect_to(user_path(@admin)) }        
            end
    
          end
    
          describe "submitting a PUT request to the InsuranceSetting#update action" do
       
            before { put insurance_setting_path(@setting) }
            specify { response.should redirect_to(user_path(@admin)) }
          end
          
        end
      end
      
      
      describe "Insurance Codes controller" do
    
        describe "when the country's Insurance control is switched on" do 
        
          describe "add a new insurance code for the country" do
      
            before { visit new_country_insurance_code_path(@country.id) }
        
            it { should have_selector('title', text: 'New Insurance Code') }
            it { should have_selector('h1', text: 'New Insurance Code') }
            it { should have_selector('h1', text: @country.country) }
            it { should have_link('All insurance codes', href: country_insurance_codes_path(@country)) }
            it { should have_link("Main insurance menu", href: insurance_menu_country_path(@country)) }
            it { should_not have_selector('#insurance_code_cancelled') }
            it { should_not have_selector('input#insurance_code_checked') }
      
            describe "with valid data" do
        
              before do        
                fill_in "Insurance code", with: "C"
                fill_in "Explanation", with: "Pension-age - contracted in"
              end
          
              it "should create a new insurance setting for the country" do
                expect { click_button "Create" }.to change(@country.insurance_codes, :count).by(1)
                page.should have_selector('h1', text: 'Insurance Codes')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: "Insurance Codes: #{@country.country}")
              end 
            end
        
            describe "with invalid data" do
           
              before do
                fill_in "Insurance code", with: "  "
              end
          
              it "should not create a new insurance code for the country" do
                expect { click_button "Create" }.not_to change(@country.insurance_codes, :count)
                page.should have_selector('h1', text: 'New Insurance Code')
                page.should have_selector('h1', text: @country.country)
                page.should have_content('error')    
              end
            end
          end
          
          describe "Insurance Codes table (index - Insurance Codes) for country" do
      
            before { visit country_insurance_codes_path(@country) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Insurance Codes: #{@country.country}") }
            it { should have_selector('h1', text: 'Insurance Codes') }
            it { should have_link('Add a new code', href: new_country_insurance_code_path(@country)) }
            it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
            it { should have_link('edit', href: edit_insurance_code_path(@code)) }
            it { should have_link('del', href: insurance_code_path(@code)) }
            it { should have_selector('#recent-adds') }
            it { should have_selector('.recent', text: "*") }
            it { should have_selector('.instruction', text: "INSURANCE CODES") }
            it { should have_selector('.instruction', text: "in our video tutorial") } 
            it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
            it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
            it { should_not have_selector('#recent-add-checks') }  #this and the following line reserved for superusers
            it { should_not have_selector('.recent', text: "+") }
        
            describe "deleting an insurance code" do
        
              it "should be from the correct country" do
                expect { click_link('del') }.to change(@country.insurance_codes, :count).by(-1)            
              end
            end
          end
          
          describe "editing an insurance code" do
          
            let(:code) { @old_code }
            before { visit edit_insurance_code_path(code) }
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Edit Insurance Code") }
            it { should have_selector('h1', text: 'Edit Insurance Code') }
            it { should have_link('All codes', href: country_insurance_codes_path(@country)) }
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should have_selector('#insurance_code_cancelled') }
            it { should_not have_selector('#insurance_code_insurance_code') }  #code cannot be edited
            it { should_not have_selector('input#insurance_code_checked') }  #only for superusers
      
            describe "updating with valid data" do
          
              before do
                fill_in "Explanation", with: 'Re-installed Code'
                fill_in "Cancellation date", with: nil
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance Codes: #{@country.country}") }
              it { should have_selector('h1', text: 'Insurance Codes') }
              specify { code.reload.explanation.should == "Re-installed Code" } 
              specify { code.reload.updated_by.should == @admin.id } 
              specify { code.reload.checked.should == false }   
                 
            end
            
            describe "cancelling a salary threshold category" do
            
              pending("Test consequences")
            end
        
            describe "updating with invalid data" do
        
              before do
                fill_in "Explanation", with: " "
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: 'Edit Insurance Code') }
              it { should have_content('error') }
              specify { code.reload.insurance_code.should_not == " " }
            end   
          end
        end
        
        describe "when the country's Insurance control is switched off" do
          
          before do
            @country.insurance = false
            @country.save
          end
          
          describe "trying to open the index page" do
          
            before { visit country_insurance_codes_path(@country) }
        
            it { should_not have_selector('h1', text: @country.country) }
            it { should_not have_selector('title', text: "Insurance Codes: #{@country.country}") }
            it { should have_selector('h1', text: 'Administrator Menu') }
          
          end
          
          describe "when trying to access the 'new' page" do
    
            before { visit new_country_insurance_code_path(@country) }
      
            it { should_not have_selector('title', text: 'New Insurance Code') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: "National Insurance is switched off for this country")
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
        
          describe "when trying to access the 'edit' page" do
    
            before { visit edit_insurance_code_path(@code) }
      
            it { should_not have_selector('title', text: 'Edit Insurance Code') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: "National Insurance is switched off for this country")
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
      
          describe "when trying to delete" do
    
            describe "submitting a DELETE request to the InsuranceCode#destroy action" do
     
              before { delete insurance_code_path(@code) }
              specify { response.should redirect_to(user_path(@admin)) }        
            end
    
          end
    
          describe "submitting a PUT request to the InsuranceCode#update action" do
       
            before { put insurance_code_path(@code) }
            specify { response.should redirect_to(user_path(@admin)) }
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
    
    describe "when Insurance is switched on" do
    
      describe "landing on Insurance Menu page" do
      
        before { visit insurance_menu_country_path(@country) }
        it { should have_selector('.instruction', text: "Set up the insurance rules") } 
        it { should_not have_link("Edit country settings", href: edit_country_path(@country)) }
      
      end
      
      describe "Insurance Settings controller" do
    
      end
      
      describe "Insurance Codes controller" do
      
        describe "entering a new code" do
        
          before { visit new_country_insurance_code_path(@country) }
          it { should have_selector('input#insurance_code_checked', value: 1) }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Insurance code", with: "Expat"
              fill_in "Explanation", with: "Applies to all expats"
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(@country.insurance_codes, :count) 
              page.should have_selector('h1', text: 'Insurance Codes')
              page.should have_selector('h1', text: @country.country)
              page.should_not have_selector('.recent', text: "+") 
            end
          end
        end
        
        describe "checking a new entry via Edit" do
         
          before do 
            @code.toggle!(:checked)
            visit edit_insurance_code_path(@code)
          end
          
          it { should have_selector('input#insurance_code_checked') }
          it { should have_selector('#update-date', text: "Added") }
          
          describe "checking the new entry in the index" do
           
            before { visit country_insurance_codes_path(@country) }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the code" do
        
            before do
              fill_in "Explanation", with: "Change the details"
              click_button "Save changes"
            end
          
            specify { @code.reload.checked == true }
            specify { @code.reload.updated_by != @superuser.id }
          end
        end
      end
      
    end
    
    describe "when Insurance is switched off" do
    
      before do
        @country.insurance = false
        @country.save
      end
      
      describe "landing on Insurance Menu page" do
      
        before { visit insurance_menu_country_path(@country) }
        it { should_not have_selector('.instruction', text: "Set up the insurance rules") } 
        it { should have_link("Edit country settings", href: edit_country_path(@country)) }
      end
      
      describe "Insurance Settings controller" do
    
      end
      
      describe "Insurance Codes controller" do
      
        describe "trying to open the index page" do
          
          before { visit country_insurance_codes_path(@country) }
        
          it { should_not have_selector('h1', text: @country.country) }
          it { should_not have_selector('title', text: "Insurance Codes") }
          it { should have_selector('h1', text: 'Administrator Menu') }
        
        end
      end
    end
  end
  
  
end
