#deals with InsuranceCodes, InsuranceSettings

require 'spec_helper'

describe "InsurancePages" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "British")
    @currency = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
    @country = FactoryGirl.create(:country, country: "United Kingdom", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, insurance: true)
    @setting = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 107, 
    										monthly_milestone: 464, annual_milestone: 5564, effective_date: Date.today-60.days, checked: true)
    @setting_old = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 425, annual_milestone: 5100, effective_date: Date.today-120.days, checked: true)
    @setting_new = @country.insurance_settings.create(shortcode: "AEL", name: "Another Earnings Limit", weekly_milestone: 110, 
    										monthly_milestone: 575, annual_milestone: 6900, effective_date: Date.today+60.days, checked: true)
    @setting_2 = @country.insurance_settings.create(shortcode: "UEL", name: "Upper Earnings Limit", weekly_milestone: 2000, 
    										monthly_milestone: 8500, annual_milestone: 102000, effective_date: Date.today-130.days, checked: true,
    										created_by: 999999) 
    @code = @country.insurance_codes.create(insurance_code: "A", explanation: "Standard employee", checked: true)	
    @old_code	= @country.insurance_codes.create(insurance_code: "Z", explanation: "Cancelled code", 
    										cancelled: Date.today - 30, checked: true, created_by: 999999)								    																				
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
  
    let(:user) { FactoryGirl.create(:user, name: "Non Admin", email: "nonadmin@example.com") }
    before do
      sign_in user
    end
  
    describe "Insurance Settings controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_insurance_setting_path(@country) }
      
        it { should_not have_selector('title', text: 'New Salary Threshold') }
        it "should render the home-page" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h1', text: 'User Home Page')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_insurance_settings_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h1', text: 'User Home Page')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceSetting#destroy action" do
          before { delete insurance_setting_path(@setting) }
          specify { response.should redirect_to user_path(user) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceSetting#update action" do
        before { put insurance_setting_path(@setting) }
        specify { response.should redirect_to user_path(user) }
      end
    end
    
    describe "Insurance Codes controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_country_insurance_code_path(@country) }
      
        it { should_not have_selector('title', text: 'New Insurance Code') }
        it "should render the home page" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h1', text: 'User Home Page')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_insurance_codes_path(@country) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h1', text: 'User Home Page')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceCodes#destroy action" do
          before { delete insurance_code_path(@code) }
          specify { response.should redirect_to user_path(user) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceCodes#update action" do
        before { put insurance_code_path(@code) }
        specify { response.should redirect_to user_path(user) }
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
      
        describe "when insurance is switched off" do
        
          before do
            @country.insurance = false
            @country.save
          end
          
          describe "attempting to open index page" do
            
            before { visit country_insurance_settings_path(@country) }
            
            it { should_not have_selector('h1', text: @country.country) }
            it { should_not have_selector('title', text: "Insurance: Current Salary Thresholds") }
            it { should have_selector('h1', text: 'Administrator Menu') }
            it { should have_selector('.alert', text: 'National Insurance is switched off') }
          end
          
          describe "attempting to open new page" do
          
            before { visit new_country_insurance_setting_path(@country) }  #reverts -default for non-country admin - same for edit, update
      
            it { should_not have_selector('title', text: 'New Salary Threshold') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: 'You must be a registered administrator')
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
        end
        
        describe "when insurance is switched on" do
        
          describe "current settings" do
          
            describe "insurance settings index (Salary Thresholds table)" do
      
              before { visit country_insurance_settings_path(@country) }
        
              describe "display standard settings" do
                it { should have_selector('h1', text: @country.country) }
                it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
                it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
                it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
                it { should have_selector("li##{@setting.id}", text: @setting.shortcode) }
                it { should have_selector("li##{@setting.id}", value: @setting.weekly_milestone) }
                it { should have_selector("li##{@setting.id}", value: @setting.monthly_milestone) }
                it { should have_selector("li##{@setting.id}", value: @setting.annual_milestone) }
                it { should have_selector("li##{@setting.id}", value: @setting.effective_date) }
                it { should_not have_selector("li##{@setting_old.id}", value: @setting_old.weekly_milestone) }
                it { should_not have_selector("li##{@setting_new.id}", value: @setting_new.weekly_milestone) }
                it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
                it { should have_link('View full history instead', href: country_insurance_history_settings_path(@country)) }
                it { should have_link('View future settings', href: country_insurance_future_settings_path(@country)) }
              end
              
              describe "display settings for this user/context" do
              
                it { should_not have_selector('.standout', text: "don't delete or edit") }
                it { should_not have_link('edit', href: edit_insurance_setting_path(@setting)) }
                it { should_not have_link('del', href: insurance_setting_path(@setting)) }
                it { should_not have_selector('#recent-adds') }
                it { should_not have_selector('#recent-add-checks') }
                it { should_not have_selector('#recent-update-checks') }
                it { should_not have_selector('.recent', text: "*") }
                it { should_not have_selector('.instruction', text: "in our video tutorial") } 
                it { should have_selector('.instruction', text: "You're not registered as an administrator") }         
                it { should_not have_selector('.itemlist', text: "Not Used Past") }
                pending("should have_selector('.itemlist', text: 'Not Used Future') }")
                it { should_not have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
                it { should_not have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
              end
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
          
          describe "future settings" do
          
            describe "index page" do
      
              before { visit country_insurance_future_settings_path(@country) }
        
              it { should_not have_selector('.standout', text: "don't delete or edit") }
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Future Salary Thresholds") }
              it { should have_selector('h1', text: 'Insurance: Future Salary Thresholds') }
              it { should have_selector("li##{@setting_new.id}", text: @setting_new.shortcode) }
              it { should_not have_selector("li##{@setting.id}", value: @setting.weekly_milestone) }
              it { should_not have_selector("li##{@setting_old.id}", value: @setting_old.weekly_milestone) }
              it { should have_selector("li##{@setting_new.id}", value: @setting_new.weekly_milestone) }
              it { should_not have_link('edit', href: edit_insurance_setting_path(@setting_new)) }
              it { should_not have_link('del', href: insurance_setting_path(@setting_new)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
              it { should_not have_selector('.instruction', text: "in our video tutorial") } 
              it { should have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should have_link('View settings history', href: country_insurance_history_settings_path(@country)) }
              it { should have_link('View current settings instead', href: country_insurance_settings_path(@country)) }
              it { should_not have_link('View future settings', href: country_insurance_future_settings_path(@country)) }
              it { should_not have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should_not have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
            end           
          
          end
          
          describe "historic settings" do
          
            describe "index page" do
      
              before { visit country_insurance_history_settings_path(@country) }
        
              it { should_not have_selector('.standout', text: "don't delete or edit") }
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Salary Threshold History") }
              it { should have_selector('h1', text: 'Insurance: Salary Threshold History') }
              it { should_not have_link('edit', href: edit_insurance_setting_path(@setting)) }
              it { should_not have_link('del', href: insurance_setting_path(@setting)) }
              it { should_not have_selector('#recent-adds') }
              it { should_not have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
              it { should_not have_selector('.instruction', text: "in our video tutorial") } 
              it { should have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should have_selector("li##{@setting_new.id}", text: @setting_new.effective_date.strftime('%d %b %y')) }
              it { should have_selector("li##{@setting.id}", text: @setting.effective_date.strftime('%d %b %y')) }
              it { should have_selector("li##{@setting_old.id}", text: @setting_old.effective_date.strftime('%d %b %y')) } 
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should_not have_link('View settings history', href: country_insurance_history_settings_path(@country)) }
              it { should have_link('View current settings instead', href: country_insurance_settings_path(@country)) }
              it { should_not have_link('View future settings', href: country_insurance_future_settings_path(@country)) }
              it { should_not have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should_not have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
            end
          end
        end
      end
      
      describe "Insurance Codes controller" do
      
        describe "when insurance is switched off" do
        
          before do
            @country.insurance = false
            @country.save
          end
          
          describe "attempting to open index page" do
            
            before { visit country_insurance_codes_path(@country) }
            
            it { should_not have_selector('h1', text: @country.country) }
            it { should_not have_selector('title', text: "Insurance Codes") }
            it { should have_selector('h1', text: 'Administrator Menu') }
            it { should have_selector('.alert', text: 'National Insurance is switched off') }
          end
          
          describe "attempting to open new page" do
          
            before { visit new_country_insurance_code_path(@country) }  #reverts -default for non-country admin - same for edit, update
      
            it { should_not have_selector('title', text: 'New Insurance Code') }
            it "should render the admin home page" do
              page.should have_selector('.alert', text: 'You must be a registered administrator')
              page.should have_selector('h1', text: 'Administrator Menu')
            end
          end
        
        end
        
        describe "when insurance is switched on" do
        
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
            it { should have_selector('.itemlist', text: @old_code.cancelled.strftime('%d %b %y')) }
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
    end
    
    describe "when user is a country admin" do
    
      before do
        CountryAdmin.create(user_id: @admin.id, country_id: @country.id)
        @setting_cancelled_past = @country.insurance_settings.create(shortcode: "NUP", name: "Not Used Past", weekly_milestone: 150, 
    										monthly_milestone: 625, annual_milestone: 7500, effective_date: Date.today-130.days, 
    										cancellation_date: Date.today-30.days, checked: true)
      end
      
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
            it { should have_link('Current thresholds list', href: country_insurance_settings_path(@country)) }
            it { should have_link("Main insurance menu", href: insurance_menu_country_path(@country)) }
            it { should_not have_selector('#insurance_setting_cancellation_date') }
            it { should_not have_selector('#update-date', text: "Added") }
            it { should_not have_selector('input#insurance_setting_checked', value: 1) }
            it { should have_selector('.line-space', text: "No blanks") }
            it { should have_selector('#insurance_setting_created_by', type: 'hidden', value: @admin.id) } 
            it { should have_selector('#insurance_setting_updated_by', type: 'hidden', value: @admin.id) }
      
            describe "with valid current data" do
        
              before do        
                fill_in "Code", with: "ST"
                fill_in "Description", with: "Secondary Threshold"
                fill_in "Weekly threshold", with: 144
                fill_in "Monthly threshold", with: 624
                fill_in "Annual threshold", with: 7488
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
                fill_in "Weekly threshold", with: 144
                fill_in "Monthly threshold", with: 624
                fill_in "Annual threshold", with: 7488
                fill_in "Effective date", with: Date.today + 60.days
              end
          
              it "should create a new insurance setting for the country but redirect to Future" do
                expect { click_button "Create" }.to change(InsuranceSetting, :count).by(1)
                page.should have_selector('h1', text: 'Insurance: Future Salary Thresholds')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: 'Insurance: Future Salary Thresholds')
                page.should have_selector('#recent-adds')
                page.should have_selector('.recent', text: "*")
                page.should_not have_selector('#recent-add-checks')
                page.should_not have_selector('.recent', text: "+")
                page.should have_selector('#change-note', text: "Changes are best seen")
              end 
            
            end
            
            describe "with valid historic data" do
            
              before do        
                fill_in "Code", with: "UEL"   #UEL record already exists formed today - 130 days
                fill_in "Description", with: "Upper Earnings Limit"
                fill_in "Weekly threshold", with: 1900
                fill_in "Monthly threshold", with: 7800
                fill_in "Annual threshold", with: 93600
                fill_in "Effective date", with: Date.today - 500.days
              end
          
              it "should create a new insurance setting for the country but redirect to History" do
                expect { click_button "Create" }.to change(InsuranceSetting, :count).by(1)
                page.should have_selector('h1', text: 'Insurance: Salary Threshold History')
                page.should have_selector('h1', text: @country.country)
                page.should have_selector('title', text: 'Insurance: Salary Threshold History')
                page.should have_selector('#recent-adds')
                page.should have_selector('.recent', text: "*")
                page.should_not have_selector('#recent-add-checks')
                page.should_not have_selector('.recent', text: "+")
                page.should_not have_selector('#change-note', text: "Changes are best seen")
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
                fill_in "Weekly threshold", with: 160
                fill_in "Monthly threshold", with: 660
                fill_in "Annual threshold", with: 7920
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
          
          describe "current Insurance Settings table (index - salary thresholds) for country" do
      
            describe "all settings checked" do
            
              before { visit country_insurance_settings_path(@country) }
        
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should have_link('cancel', href: edit_insurance_setting_path(@setting)) }
              it { should_not have_link('del', href: insurance_setting_path(@setting)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
              it { should_not have_selector('.itemlist', text: "Not Used Past") }
              pending("it { should have_selector('.itemlist', text: 'Not Used Future') }")
              it { should_not have_selector('#recent-add-checks') }
              it { should_not have_selector('.recent', text: "+") }
              it { should have_selector('#change-note', text: "Changes are best seen") }
              it { should_not have_selector("li##{@setting_new.id}", text: @setting_new.effective_date.strftime('%d %b %y')) }
              it { should have_selector("li##{@setting.id}", text: @setting.effective_date.strftime('%d %b %y')) }
              it { should_not have_selector("li##{@setting_old.id}", text: @setting_old.effective_date.strftime('%d %b %y')) } 
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
        
              describe "moving to the insurance settings 'cancel' link in the correct country" do
                before { click_link 'cancel' }
          
                it { should have_selector('title', text: "Cancel Salary Threshold Code") }
                it { should have_selector('h1', text: @country.country) }
        
              end
            end
            
            describe "with an unchecked setting" do 
            
              before do
                @setting.toggle!(:checked)
                visit country_insurance_settings_path(@country)
              end
              
              it { should have_link('edit', href: edit_insurance_setting_path(@setting)) }
              it { should have_link('del', href: insurance_setting_path(@setting)) }
              
              describe "using the delete button" do
        
                it "should remove the record" do
                  expect { click_link('del') }.to change(InsuranceSetting, :count).by(-1)            
                end
              end
            end
          end
          
          describe "editing a salary thresholds line (unchecked records only)" do
          
            before do
              @setting_2.toggle!(:checked)
              visit edit_insurance_setting_path(@setting_2)
            end
        
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Edit Salary Thresholds") }
            it { should have_selector('h1', text: 'Edit Salary Thresholds') }
            it { should have_link('Current thresholds list', href: country_insurance_settings_path(@country)) }
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should have_selector('#insurance_setting_shortcode') }
            it { should have_selector('#insurance_setting_name') }
            it { should have_selector('#insurance_setting_weekly_milestone') }
            it { should_not have_selector('#insurance_setting_cancellation_date') }
            it { should have_selector('#insurance_setting_created_by', type: 'hidden', value: 999999) }
            it { should have_selector('#insurance_setting_updated_by', type: 'hidden', value: @admin.id) }
            it { should_not have_selector('#update-date', text: "Added") }
      
            describe "updating with valid data" do
          
              before do
                fill_in "Description", with: 'Upper Accrual Limit'
                fill_in "Weekly threshold", with: 1080
                fill_in "Monthly threshold", with: 4000
                fill_in "Annual threshold", with: 48000
                click_button "Save changes"
              end
          
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Current Salary Thresholds") }
              it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
              it { have_selector('#change-note', "Changes are best seen") }
              pending("next lines don't work because only recently entered - * takes precedence over ^")
              #it { should have_selector('.updates', text: "^") }
              #it { should_not have_selector('.updates', text: "<") }
              specify { @setting_2.reload.name.should == "Upper Accrual Limit" }    
              specify { @setting_2.reload.checked.should == false } 
              specify { @setting_2.reload.updated_by.should == @admin.id }    
            end
            
            describe "updating with invalid data" do
            
              before do
                fill_in "Monthly threshold", with: nil
                click_button "Save changes"
              end
              
              it { should have_selector('title', text: "Edit Salary Thresholds") } 
              specify { @setting_2.reload.name.should == "Upper Earnings Limit" }
              specify { @setting_2.reload.monthly_milestone.should == 8500 } 
            end
          
          end
          
          describe "cancelling a salary thresholds line (checked records only)" do
            
            before { visit edit_insurance_setting_path(@setting) }
            
            it { should have_selector('h1', text: @country.country) }
            it { should have_selector('title', text: "Cancel Salary Threshold Code") }
            it { should have_selector('h1', text: 'Cancel Salary Threshold Code') }
            it { should have_link('Current thresholds list', href: country_insurance_settings_path(@country)) }
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should_not have_selector('#insurance_setting_shortcode') }
            it { should_not have_selector('#insurance_setting_name') }
            it { should_not have_selector('#insurance_setting_weekly_milestone') }
            it { should have_selector('#insurance_setting_cancellation_date') }
            it { should have_selector('#insurance_setting_updated_by', type: 'hidden', value: @admin.id) }
            it { should_not have_selector("insurance_setting_cancellation_change") }
            it { should_not have_selector('#update-date', text: "Added") }
              
            describe "cancellation date has already passed" do
              
              before do
                fill_in "Cancellation date", with: (Date.today - 1.day)
                click_button "Save changes"
              end
                
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('h1', text: 'Insurance: Salary Threshold History') }
              it { should have_selector('div.alert.alert-success', text: "It will still be displayed in the History list") }
              it { should have_selector("li##{@setting.id}", text: "Cancelled #{date_display(Date.today - 1.day)}") }
              it { should_not have_selector("li##{@setting_old.id}", text: "Cancelled #{date_display(Date.today - 1.day)}") }
              it { should have_selector("div.alert.alert-success", text: "Don't forget to reset National Insurance Rates") }
              it { should have_selector("div.alert.alert-success", text: "'#{@setting.shortcode}' category") }
              it { should have_selector("div.alert.alert-success", text: "from #{(Date.today - 1.day).strftime('%d %b %Y')}") }
              it { should have_link("restore", href: edit_insurance_setting_path(@setting)) }
              it { should_not have_link("restore", href: edit_insurance_setting_path(@setting_old)) }
              specify { @setting_old.reload.cancellation_date.should == Date.today - 1.day }
              #cancellation change for @setting_old is marked, but only most recent cancellation is shown in history.  
              
              
              describe "removal of cancelled setting from current list" do  
              
                before { visit country_insurance_settings_path(@country) }
                it { should_not have_selector("li##{@setting.id}", text: @setting.effective_date.strftime('%d %b %y')) }
              end
    
              describe "superuser is alerted of cancellation change" do
              
                before do
                  #sign_out @admin
                  @superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
                  sign_in @superuser
                  visit country_insurance_history_settings_path(@country)
                end
              
                it { should have_selector("li##{@setting.id}", text: ">") }
              end
              
              describe "restoring a cancelled setting" do
              
                before do
                  @setting.update_attributes(cancellation_date: Date.today - 1)
                  @setting_old.update_attributes(cancellation_date: Date.today - 1)
                  
                end
                
                describe "Edit Form display" do
                
                  before { visit edit_insurance_setting_path(@setting) }
                 
                  it { should have_selector('h1', text: "Restore Salary Threshold Code") }
                  it { should have_selector('.instruction', text: "Looks like someone's made a mistake.") }
                  it { should_not have_selector("insurance_setting_cancellation_change") }
                 
                  describe "cancelling the cancellation" do
                  
                    before do
                      fill_in "Cancellation date", with: nil
                      click_button "Save changes"
                    end
                    
                    it { should have_selector('h1', text: @country.country) }
                    it { should have_selector('h1', text: 'Insurance: Salary Threshold History') }
                    it { should have_selector('div.alert.alert-success', text: "You've just re-activated") }
                    it { should_not have_selector("li##{@setting.id}", text: "Cancelled #{date_display(Date.today - 1.day)}") }
                    it { should_not have_selector("li##{@setting_old.id}", text: "Cancelled #{date_display(Date.today - 1.day)}") }
                    it { should have_selector("div.alert.alert-success", text: "the setting for '#{@setting.shortcode}'") }
                    it { should have_selector("div.alert.alert-success", text: "of #{@setting.effective_date.to_date.strftime('%d %b %Y')}") }
                    it { should have_link("cancel", href: edit_insurance_setting_path(@setting)) }
                    it { should_not have_link("cancel", href: edit_insurance_setting_path(@setting_old)) }
                    specify { @setting_old.reload.cancellation_date.should == nil } 
                    
                  end
                end
              end
            end
              
            describe "cancellation date is in the future" do
                
              before do
                fill_in "Cancellation date", with: (Date.today + 10.days)
                click_button "Save changes"
              end
                
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
              it { should have_selector('div.alert.alert-success', text: "but for a date in the future") }
              it { should have_selector('div.alert.alert-success', text: "Don't forget to reset National Insurance Rates") }
              it { should have_selector('.itemlist', text: "Cancelled from #{date_display(Date.today + 10.days)}") }
            end  
            
          end
          
          describe "editing a threshold setting that has already been cancelled" do
            
            let(:setting) { @setting_cancelled_past }
            before { visit edit_insurance_setting_path(setting) }
            
            it { should have_link('Main insurance menu', href: insurance_menu_country_path(@country)) } 
            it { should have_selector('#insurance_setting_cancellation_date') }
            it { should_not have_selector("insurance_setting_cancellation_change") }
        
            describe "cancel the cancellation date" do        
              
              before do
                fill_in "Cancellation date", with: nil
                click_button "Save changes"
              end
                
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('h1', text: 'Insurance: Salary Threshold History') }
              it { should have_selector('.itemlist', text: setting.shortcode) }
              it { should_not have_selector('.itemlist', text: "Cancelled #{date_display(Date.today - 30.days)}") }
            end
          
            describe "changing the cancellation date after the cancellation has already been accepted" do
          
              before do
                fill_in "Cancellation date", with: Date.today + 2.days
                click_button "Save changes"
              end
              
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('h1', text: 'Insurance: Current Salary Thresholds') }
              it { should have_selector("li##{@setting_cancelled_past.id}", text: setting.shortcode) }
              it { should have_selector("li##{@setting_cancelled_past.id}", text: "Cancelled from #{date_display(Date.today + 2.days)}") }
              it { should_not have_link("edit", href: edit_insurance_setting_path(@setting_cancelled_past)) }
              it { should have_link("restore", href: edit_insurance_setting_path(@setting_cancelled_past)) }
            end
          end
          
          describe "trying to set a cancellation date when a future setting for the code already exists" do
          
            before do
              @setting_new_insert = @country.insurance_settings.create(shortcode: "AEL", name: "Another Earnings Limit", 
                    weekly_milestone: 100, monthly_milestone: 450, annual_milestone: 5400, effective_date: Date.today-60.days,
                    checked: true)
              visit edit_insurance_setting_path(@setting_new_insert)
            end
          
            describe "set cancellation_date" do
              
              before do
                fill_in "Cancellation date", with: Date.today
                click_button "Save changes"
              end
              
              #user is required to remove the future setting first - deliberately not automated.
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: 'Edit Salary Thresholds') }
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
          
          describe "dealing with future settings" do
          
            describe "index page" do
            
              before { visit country_insurance_future_settings_path(@country) }
        
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Insurance: Future Salary Thresholds") }
              it { should have_selector('h1', text: 'Insurance: Future Salary Thresholds') }
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should_not have_link('edit', href: edit_insurance_setting_path(@setting_new)) }
              it { should have_link('del', href: insurance_setting_path(@setting_new)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
              
              it { should_not have_selector('#recent-add-checks') }
              it { should_not have_selector('.recent', text: "+") }
              it { should have_selector('#change-note', text: "Changes are best seen") }
              it { should have_selector("li##{@setting_new.id}", text: @setting_new.effective_date.strftime('%d %b %y')) }
              it { should_not have_selector("li##{@setting.id}", text: @setting.effective_date.strftime('%d %b %y')) }
              it { should_not have_selector("li##{@setting_old.id}", text: @setting_old.effective_date.strftime('%d %b %y')) } 
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
            end
          end
          
          describe "dealing with settings history" do
          
            describe "index page" do
            
              before { visit country_insurance_history_settings_path(@country) }
            
              it { should have_selector('h1', text: @country.country) }
              it { should have_selector('title', text: "Salary Threshold History") }
              it { should have_selector('h1', text: 'Salary Threshold History') }
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should_not have_link('edit', href: edit_insurance_setting_path(@setting_new)) }
              it { should_not have_link('del', href: insurance_setting_path(@setting_old)) }
              it { should have_selector('#recent-adds') }
              it { should have_selector('.recent', text: "*") }
              it { should have_selector('.instruction', text: "SALARY THRESHOLDS") }
              it { should have_selector('.instruction', text: "in our video tutorial") } 
              it { should_not have_selector('.instruction', text: "You're not registered as an administrator") }
              it { should_not have_selector('.instruction', text: "We're still looking for administrators") }
              
              it { should_not have_selector('#recent-add-checks') }
              it { should_not have_selector('.recent', text: "+") }
              it { should have_selector("li##{@setting_new.id}", text: @setting_new.effective_date.strftime('%d %b %y')) }
              it { should have_selector("li##{@setting.id}", text: @setting.effective_date.strftime('%d %b %y')) }
              it { should have_selector("li##{@setting_old.id}", text: @setting_old.effective_date.strftime('%d %b %y')) } 
              it { should have_link('Add a new salary threshold', href: new_country_insurance_setting_path(@country)) }
              it { should have_link('Update all current settings', href: new_country_insurance_threshold_path(@country)) }
            end
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
            it { should have_selector('#insurance_code_created_by', type: 'hidden', value: @admin.id) }
            it { should have_selector('#insurance_code_updated_by', type: 'hidden', value: @admin.id) }
      
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
            it { should have_selector('#insurance_code_created_by', type: 'hidden', value: 999999) }
            it { should have_selector('#insurance_code_updated_by', type: 'hidden', value: @admin.id) }
      
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
      @setting_2.update_attributes(cancellation_date: Date.today, cancellation_change: true)
      @cancelled_setting = @country.insurance_settings.create(shortcode: "ST", name: "Secondary Threshold", weekly_milestone: 150, 
    				monthly_milestone: 600, annual_milestone: 7200, effective_date: Date.today-130.days, checked: true,
    				created_by: 999999, cancellation_date: Date.today - 1.day, cancellation_change: true) 
      @restored_setting = @country.insurance_settings.create(shortcode: "RST", name: "Restored Setting", weekly_milestone: 250, 
    				monthly_milestone: 1000, annual_milestone: 12000, effective_date: Date.today-130.days, checked: true,
    				created_by: 999999, cancellation_date: nil, cancellation_change: true) 
      
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
        
        describe "viewing the index page" do
        
          before { visit country_insurance_settings_path(@country) }
         
          it { should_not have_selector("li##{@setting_2.id}") }
          it { should_not have_selector("li##{@cancelled_setting.id}") }
          it { should have_selector("li##{@restored_setting.id}") }
        end
        
        describe "viewing the index history" do
        
          before { visit country_insurance_history_settings_path(@country) }
        
          it { should have_selector("li##{@setting_2.id}", text: ">") }
          it { should have_selector("li##{@setting_2.id}", text: "Cancelled") }
          it { should have_selector("li##{@cancelled_setting.id}", text: ">") } 
          it { should have_selector("li##{@cancelled_setting.id}", text: "Cancelled") }
          it { should have_selector("li##{@restored_setting.id}", text: ">") }  #superuser has already dealt with this
          it { should_not have_selector("li##{@restored_setting.id}", text: "Cancelled") }
        end
        
        describe "entering a new setting" do
   
          before { visit new_country_insurance_setting_path(@country) }
          it { should have_selector('input#insurance_setting_checked', value: 1) }
          it { should_not have_selector('#insurance_setting_cancellation_date') }
          it { should_not have_selector('#update-date', text: "Added") }
          
          describe "automatic checking of record entered by superuser" do
            before do
              fill_in "Code", with: "XYZ"   #UEL record already exists formed today - 130 days
              fill_in "Description", with: "XYZ Descriptor"
              fill_in "Weekly threshold", with: 900
              fill_in "Monthly threshold", with: 3600
              fill_in "Annual threshold", with: 44000
              fill_in "Effective date", with: Date.today
            end
            
            it "should create the new record" do
            
              expect { click_button "Create" }.to change(@country.insurance_settings, :count) 
              page.should have_selector('h1', text: 'Salary Threshold')
              page.should have_selector('h1', text: @country.country)
              page.should_not have_selector('.recent', text: "+") 
            end
          end
        end
       
        describe "checking a new entry via Edit" do
         
          before do 
            @setting.toggle!(:checked)
            visit edit_insurance_setting_path(@setting)
          end
          
          it { should have_selector('input#insurance_setting_checked') }
          it { should have_selector('#update-date', text: "Added") }
          it { should_not have_selector('#insurance_setting_cancellation_change') }
          
          describe "checking the new entry in the index" do
           
            before { visit country_insurance_settings_path(@country) }
            
            it { should_not have_selector('#recent-adds') }
            it { should_not have_selector('.recent', text: "*") }
            it { should have_selector('#recent-add-checks') }
            it { should have_selector('.recent', text: "+") }
          end
          
          describe "not changing updated and checked status when superuser edits the code" do
        
            before do
              fill_in "Description", with: "foobar"
              click_button "Save changes"
            end
          
            specify { @setting.reload.checked == true }
            specify { @setting.reload.updated_by != @superuser.id }
          end
        end
      end
      
      describe "checking a new entry when cancellation status has changed" do
        
        describe "when setting has just been cancelled" do
        
          before { visit edit_insurance_setting_path(@cancelled_setting) }
          
          it { should have_selector("#insurance_setting_cancellation_change") }
        end
        
        describe "when setting has just been restored" do
        
          before { visit edit_insurance_setting_path(@restored_setting) }
          
          it { should have_selector("#insurance_setting_cancellation_change") }
        end
        
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
