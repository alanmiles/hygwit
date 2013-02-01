#deals with annual updating of insurance thresholds and rates
#specifically insurance_thresholds and insurance_sets controllers

require 'spec_helper'

describe "InsuranceUpdates" do
  
  subject { page }
  
  before do
    @nationality = FactoryGirl.create(:nationality, nationality: "British")
    @currency = FactoryGirl.create(:currency, currency: "Pounds Sterling", code: "GBP")
    @country = FactoryGirl.create(:country, country: "United Kingdom", nationality_id: @nationality.id, 
    																				currency_id: @currency.id, insurance: true)
    @code_1 = @country.insurance_codes.create(insurance_code: "A", explanation: "Default employee")
  end
  
  describe "when the user is not permitted to update the country's insurance rates" do

    before do
      @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
      @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
      @rate_1 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
      @rate_2 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 12, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
    end
    
    describe "when the user is not signed in" do
      
      describe "when the user tries to add new thresholds" do
      
        before { visit new_country_insurance_threshold_path(@country) }
        
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
      end
      
      describe "when trying to change threshold data" do
      
        describe "with a PUT request" do
          before { put insurance_threshold_path(@rate_1) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete insurance_threshold_path(@rate_1) }
          specify { response.should redirect_to(root_path) }        
        end
      end
      
      describe "when the user tries to add new rates" do
      
        before { visit new_country_insurance_set_path(@country) }
        
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
      end
      
      describe "when trying to change rate data" do
      
        describe "with a PUT request" do
          before { put insurance_set_path(@rate_1) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete insurance_set_path(@rate_1) }
          specify { response.should redirect_to(root_path) }        
        end
      end
  
    end
  end
    
  describe "when the user is signed in but not as an administrator" do
  
    before do
      @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
      @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
      @rate_1 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
      @rate_2 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 12, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
      user = FactoryGirl.create(:user, name: "Non Admin", email: "nonadmin@example.com") 
      sign_in user 
    end
      
    describe "when the user tries to add new thresholds" do
      
      before { visit new_country_insurance_threshold_path(@country) }
        
      it "should render the root_path" do
        page.should have_selector('.alert', text: 'You must be a HROomph admin')
        page.should have_selector('h2', text: 'Less HR - More Achievement.')
      end
    end
      
    describe "when the user tries to change the threshold data" do  
        
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceThresold#destroy action" do
          before { delete insurance_threshold_path(@rate_1) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceThreshold#update action" do
        before { put insurance_threshold_path(@rate_1) }
        specify { response.should redirect_to(root_path) }
      end
       
    end
      
    describe "when the user tries to add new rates" do
      
      before { visit new_country_insurance_set_path(@country) }
        
      it "should render the root_path" do
        page.should have_selector('.alert', text: 'You must be a HROomph admin')
        page.should have_selector('h2', text: 'Less HR - More Achievement.')
      end
    end
      
    describe "when the user tries to change the rate data" do  
        
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the InsuranceSet#destroy action" do
          before { delete insurance_set_path(@rate_1) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the InsuranceSet#update action" do
        before { put insurance_set_path(@rate_1) }
        specify { response.should redirect_to(root_path) }
      end
       
    end
  
          
  end
  
  describe "when the user is signed in as an administrator but not as a country administrator" do
      
    before do
      @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
      @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
      @rate_1 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
      @rate_2 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 12, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
    	@rate_1_employer = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 13, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: false)	
      @rate_2_employer = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 15, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: false)										
      @admin = FactoryGirl.create(:admin, name: "An Admin", email: "anadmin@example.com")
      sign_in @admin
    end
      
    describe "when insurance for the country is switched on" do
      
      describe "when the user tries to add new thresholds" do
      
        before { visit new_country_insurance_threshold_path(@country) }
        
        describe "trying to open the 'new' page" do
          
          it "should render the admin home page" do      
            page.should have_selector('.alert', text: 'You must be a registered administrator')
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end 
        
      end
      
      describe "when the user tries to add new rates" do
      
        before { visit new_country_insurance_set_path(@country) }
        
        it "should render the admin home page" do      
          page.should have_selector('.alert', text: 'You must be a registered administrator')
          page.should have_selector('h1', text: 'Administrator Menu')
        end
      end
      
    end
    
    describe "when insurance for the country is switched off" do
    
      before do
        @country.toggle!(:insurance)
      end
      
      describe "trying to add new thresholds" do
      
        before { visit new_country_insurance_threshold_path(@country) }
        
        it "should render the admin home page" do      
          page.should have_selector('.alert', text: 'You must be a registered administrator')
          page.should have_selector('h1', text: 'Administrator Menu')
        end
      end
      
      describe "trying to add new rates" do
      
        before { visit new_country_insurance_set_path(@country) }
        
        it "should render the admin home page" do      
          page.should have_selector('.alert', text: 'You must be a registered administrator')
          page.should have_selector('h1', text: 'Administrator Menu')
        end
      end
    
    end
  end
    
  describe "when the user has permission to update the country's insurance rates" do
  
    describe "when the user is signed in as a country administrator" do
  
      before do
        @admin = FactoryGirl.create(:admin, name: "Another Admin", email: "anotheradmin@example.com")
        CountryAdmin.create(user_id: @admin.id, country_id: @country.id)
        sign_in @admin
      end
      
      describe "when insurance for the country is switched on" do
      
        describe "when there have been no previous threshold or rate entries for the country" do
        
          describe "dealing with thresholds" do
       
            describe "when the user tries to add new thresholds" do
      
              before { visit new_country_insurance_threshold_path(@country) }
            
              it "should return to the current insurance settings page" do      
                page.should have_selector('.alert', text: 'You must have at least')
                page.should have_selector('h1', text: 'Insurance: Current Salary Thresholds')
              end
              
            end
           
          end
          
          describe "dealing with rates" do
            describe "when the user tries to add new rates" do
              
              before { visit new_country_insurance_set_path(@country) }
              
              it "should return to the country's insurance menu page" do      
                page.should have_selector('.alert', text: 'You must have at least')
                page.should have_selector('h1', text: 'National Insurance Menu')
              end
            end
          
          end
        end
          
        describe "when there have been previous threshold and rate entries for the country" do
          
          before do
            @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
            @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
            @rate_1 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
            @rate_2 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 12, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
            
          end
            
          describe "dealing with thresholds" do 
      
            before { visit new_country_insurance_threshold_path(@country) }
              
            it { should have_selector('h1', text: 'Refresh All Salary Threshold Settings') }
            it { should have_selector('input#insurance_setting_effective_date') }
            
            describe "and setting a valid effective date" do
              
              before do
                fill_in "Effective date", with: Date.today + 60.days 
                click_button "Create"
              end
              
              it { should have_selector('h1', text: 'New Salary Thresholds: National Insurance') }
              it { should have_selector('.instruction', text: 'update the salary thresholds to the new values') }
              it { should have_selector('.alert', text: 'salary thresholds has been successfully created') }
              it { should have_link('Back to current salary thresholds', href: country_insurance_settings_path(@country)) }
              it { should have_link('Back to main insurance menu', href: insurance_menu_country_path(@country)) }
              it { should have_selector('.itemlist', text: @setting_1.shortcode) }
              it { should have_selector('.itemlist', text: @setting_1.name) }
              it { should have_selector('.itemlist', value: @setting_1.weekly_milestone) }
              it { should have_selector('.itemlist', value: @setting_1.monthly_milestone) }
              it { should have_selector('.itemlist', value: @setting_1.annual_milestone) }
              it { should have_selector('.itemlist', text: (Date.today + 60.days).strftime('%d %b %y')) }
              it { should have_link('edit', href: edit_insurance_threshold_path(@country.insurance_settings.last)) }
              it { should have_link('del', href: insurance_threshold_path(@country.insurance_settings.last)) }
            
              describe "modifying the new threshold setting" do
              
                before do
                  @new_threshold = @country.insurance_settings.last
                end
                
                describe "by editing the record" do
                  
                  before { visit edit_insurance_threshold_path(@new_threshold) }
                  
                  it { should have_selector('h1', text: "Edit New Salary Threshold") }
                  it { should have_selector('#date-val', text: (Date.today + 60.days).strftime('%d %b %Y')) }
                  it { should have_selector('#insurance_setting_shortcode', value: @setting_1.shortcode) }
                  it { should have_selector('#insurance_setting_name', value: @setting_1.name) }
                  it { should have_selector('#insurance_setting_monthly_milestone', value: @setting_1.monthly_milestone) }
                  it { should have_selector('#insurance_setting_weekly_milestone', value: @setting_1.weekly_milestone) }
                  it { should have_selector('#insurance_setting_annual_milestone', value: @setting_1.annual_milestone) }
                  it { should_not have_selector('#insurance_setting_effective_date') }
                
                  describe "and then updating the record" do
                    
                    before do
                      fill_in "Weekly threshold", with: 1000
                      click_button "Save changes"
                    end
                    
                    it { should have_selector('h1', text: 'New Salary Thresholds: National Insurance') }
                    it { should have_selector('.itemlist', value: 1000) }
                  
                    describe "it should not overwrite the edited record if thresholds are updated again with the same effective date" do
                    
                      before do
                        visit new_country_insurance_threshold_path(@country)
                        fill_in "Effective date", with: Date.today + 60.days 
                        click_button "Create"
                      end
                      
                      it { should have_selector('h1', text: 'New Salary Thresholds: National Insurance') }
                      it { should have_selector('.itemlist', value: 1000) }
                      it { should have_selector('.itemlist', value: @setting_1.monthly_milestone) }
                    end  
                  end
                end
                
                describe "by deleting the record" do
                
                  describe "submitting a DELETE request to the InsuranceThreshold#destroy action" do
                    before { delete insurance_threshold_path(@new_threshold) }
                    
                    it "should delete the record" do
                      expect { click_link('del') }.to change(@country.insurance_settings, :count).by(-1)
                      page.should have_selector('h1', text: 'New Salary Thresholds: National Insurance')      
                    end
                  end
                end
              end
            
            end
            
            describe "and setting an invalid effective date" do
              
              before do
                fill_in "Effective date", with: "" 
                click_button "Create"
              end
              
              it { should have_selector('h1', text: 'Refresh All Salary Threshold Settings') }
              it { should have_selector('input#insurance_setting_effective_date') }
              it { should have_selector('.alert-error', text: "You must set an effective date") }
            end     
          end
          
          describe "dealing with rates" do
                   
            describe "when the user adds new rates" do
      
              before { visit new_country_insurance_set_path(@country) }
              
              it { should have_selector('h1', text: 'Set New Insurance Rates') }
              it { should have_selector('input#insurance_rate_effective') }
              
              describe "but fails to set an effective date" do
              
                before do
                  fill_in "Effective date", with: "" 
                  click_button "Create"
                end
              
                it { should have_selector('h1', text: 'Set New Insurance Rates') }
                it { should have_selector('input#insurance_rate_effective') }
                it { should have_selector('.alert-error', text: "You must set an effective date") }
              end
              
              describe "and sets an effective date" do
              
                describe "which predates existing threshold settings" do
                
                  before do
                    fill_in "Effective date", with: Date.today - 360.days 
                    click_button "Create"
                  end
                  
                  it { should have_selector('h1', text: 'Set New Insurance Rates') }
                  it { should have_selector('input#insurance_rate_effective') }
                  it { should have_selector('.alert', text: "No new rates can be created") }
                end
                
                describe "which is later than existing threshold settings" do
                
                  before do
                    fill_in "Effective date", with: Date.today + 60.days 
                    click_button "Create"
                    @first_rate = @country.insurance_rates
                      .where("effective =? and insurance_code_id =? and threshold_id =?", Date.today + 60.days, @code_1.id, @setting_1.id)
                      .first
                  end
                  
                  it { should have_selector('h1', text: 'New National Insurance Rates Set - Employees') }
                  it { should have_selector('.alert', text: 'This is the National Insurance table for') }
                  it { should have_link('edit', href: edit_insurance_set_path(@first_rate)) }
                  it { should have_link('del', href: insurance_set_path(@first_rate)) }
                  it { should have_selector('.itemlist', text: @code_1.insurance_code) }
                  it { should have_selector('.itemlist', value: @setting_1.monthly_milestone) }
                  it { should have_selector('.itemlist', value: @setting_2.monthly_milestone) }
                  it { should have_selector('.itemlist', value: @rate_1.contribution) }
                  it { should have_selector('.itemlist', text: "%") }
                  it { should have_selector('.itemlist', text: (Date.today + 60.days).strftime('%d %b %y')) }
                  it { should have_link('Switch to rates for EMPLOYERS', href: country_insurance_employer_sets_path(@country)) }
                  
                  describe "modifying the new rates setting" do
              
                    describe "by editing the record" do
                  
                      before { visit edit_insurance_set_path(@first_rate) }
                  
                      it { should have_selector('h1', text: "Edit New Insurance Rate") }
                      it { should have_selector('.line-space', text: (Date.today + 60.days).strftime('%d %b %Y')) }
                      it { should have_selector('.line-space', value: @first_rate.insurance_code.insurance_code) }
                      it { should have_selector('.line-space', value: @first_rate.threshold.shortcode) }
                      it { should have_selector('.line-space', value: @first_rate.ceiling.monthly_milestone) }
                      it { should have_selector('#insurance_rate_contribution', value: @rate_1.contribution) }
                      it { should have_selector('#insurance_rate_percent_true', value: @rate_1.percent) }
                      it { should_not have_selector('#insurance_set_effective') }
                      it { should have_link('All new rates', href: country_insurance_sets_path(@country)) }
                      
                
                      describe "and then updating the record" do
                    
                        before do
                          fill_in "Contribution", with: 5.15
                          click_button "Save changes"
                        end
                    
                        it { should have_selector('h1', text: 'New National Insurance Rates Set - Employees') }
                        it { should have_selector('.itemlist', value: 5.15) }
                  
                        describe "it should not overwrite the edited record if rates are updated again with the same effective date" do
                    
                          before do
                            visit new_country_insurance_set_path(@country)
                            fill_in "Effective date", with: Date.today + 60.days 
                            click_button "Create"
                          end
                      
                          it { should have_selector('h1', text: 'New National Insurance Rates Set - Employees') }
                          it { should have_selector('.itemlist', value: 5.15) }
                          it { should have_selector('.itemlist', value: @first_rate.threshold.shortcode) }
                        end  
                      end
                    end
                
                    describe "by deleting the record" do
                
                      describe "submitting a DELETE request to the InsuranceSet#destroy action" do
                    
                        it "should delete the record" do
                          expect { click_link('del') }.to change(@country.insurance_rates, :count).by(-1)
                          page.should have_selector('h1', text: 'New National Insurance Rates Set - Employees')      
                        end
                      end
                    end
                  end 
                end
              end
              
            end
          end
        end 
      end
      
      describe "when insurance for the country is switched off" do
    
        before do
          @country.toggle!(:insurance)
        end
      
        describe "trying to add new thresholds" do
      
          before { visit new_country_insurance_threshold_path(@country) }
        
          it "should return to the admin page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "trying to add new rates" do
      
          before { visit new_country_insurance_set_path(@country) }
        
          it "should return to the admin page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
    
      end
  
    end

  
    describe "when the user is signed in as a superuser" do
  
      before do
        @superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
        sign_in @superuser 
      end
      
      describe "when insurance for the country is switched on" do
      
        describe "when there have been no previous threshold or rate entries for the country" do
        
        end
        
        describe "when there have been previous threshold or rate entries for the country" do
          before do
            @setting_1 = @country.insurance_settings.create(shortcode: "LEL", name: "Lower Earnings Limit", weekly_milestone: 100, 
    										monthly_milestone: 400, annual_milestone: 4800, effective_date: Date.today - 60.days)
            @setting_2 = @country.insurance_settings.create(shortcode: "PT", name: "Primary Threshold", weekly_milestone: 200, 
    										monthly_milestone: 800, annual_milestone: 9600, effective_date: Date.today - 60.days)
            @rate_1 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_1.id, 
    										ceiling_id: @setting_2.id, contribution: 10, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
            @rate_2 = @country.insurance_rates.create(insurance_code_id: @code_1.id, threshold_id: @setting_2.id, 
    										contribution: 12, created_by: 999999, updated_by: 999999,
    										effective: Date.today - 60.days, checked: true, source_employee: true)	
            
          end
        
          describe "dealing with thresholds" do 
      
            before { visit new_country_insurance_threshold_path(@country) }
              
            it { should have_selector('h1', text: 'Refresh All Salary Threshold Settings') }
            it { should have_selector('input#insurance_setting_effective_date') }
                
          end
          
          describe "dealing with rates" do 
      
            before { visit new_country_insurance_set_path(@country) }
              
            it { should have_selector('h1', text: 'Set New Insurance Rates') }
            it { should have_selector('input#insurance_rate_effective') }
                
          end
        end
      end
      
      describe "when insurance for the country is switched off" do
    
        before do
          @country.toggle!(:insurance)
        end
      
        describe "trying to add new thresholds" do
      
          before { visit new_country_insurance_threshold_path(@country) }
        
          it "should return to the admin page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
      
        describe "trying to add new rates" do
      
          before { visit new_country_insurance_set_path(@country) }
        
          it "should return to the admin page" do
            page.should have_selector('.alert', text: "National Insurance is switched off for this country")
            page.should have_selector('h1', text: 'Administrator Menu')
          end
        end
    
      end
    end
  end
end
