require 'spec_helper'

describe "AbsencePages" do
  
  subject { page }
  
  before do
    @absence = AbsenceType.create(absence_code: "UL", paid: 0, notes: "Unpaid leave") 
  end
  
  describe "when not logged in" do
  
    describe "AbsenceTypes controller" do
    
      before { visit new_absence_type_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit absence_types_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the absence_type data" do
        
        describe "with a PUT request" do
          before { put absence_type_path(@absence) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete absence_type_path(@absence) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
    describe "CountryAbsences controller" do
    
      before do
        @nationality = FactoryGirl.create(:nationality, nationality: "German")
        @currency = FactoryGirl.create(:currency, currency: "Marks", code: "DM")
        @country = FactoryGirl.create(:country, country: "Germany", nationality_id: @nationality.id, currency_id: @currency.id)
      end 
      
      let(:country_absence) { CountryAbsence.find_by_country_id_and_absence_code(@country.id, @absence.absence_code) }
     
      describe "when trying to access the 'new' page" do
      
        before { visit new_country_country_absence_path(@country) }
        it "should render the home page" do
          page.should have_selector('.alert', text: 'Please sign in')
          page.should have_selector('h1', text: 'Sign in') 
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_country_absences_path(@country) }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to change the absence_type data" do
      
        describe "with a PUT request" do
          before { put country_absence_path(country_absence) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete country_absence_path(country_absence) }
          specify { response.should redirect_to(root_path) }        
        end
      end
      
    end  
  end
  
  describe "when logged in as non-admin" do
  
    before do
      user = FactoryGirl.create(:user, name: "Abscheck", email: "abscheck@example.com") 
      sign_in user
    end
    
    describe "AbsenceTypes controller" do
    
      describe "accessing the 'new' page" do
    
        before { visit new_absence_type_path }
      
        it { should_not have_selector('title', text: 'New Absence Type') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit absence_types_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the AbsenceTypes#destroy action" do
          before { delete absence_type_path(@absence) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the AbsenceTypes#update action" do
        before { put absence_type_path(@absence) }
        specify { response.should redirect_to(root_path) }
      end
    
    end
    
    describe "CountryAbsences controller" do
    
      before do
        @nationality = FactoryGirl.create(:nationality, nationality: "German")
        @currency = FactoryGirl.create(:currency, currency: "Mark", code: "DM")
        @country = FactoryGirl.create(:country, country: "Germany", nationality_id: @nationality.id, currency_id: @currency.id)
      end 
      
      let(:country_absence) { CountryAbsence.find_by_country_id_and_absence_code(@country.id, @absence.absence_code) }
      
      describe "accessing the 'new' page" do
    
        before { visit new_country_country_absence_path(@country) }
      
        it { should_not have_selector('title', text: 'New Absence Type') }
        it "should render the root_path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_country_absences_path(@country) }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
    
      describe "when trying to delete" do
    
        describe "submitting a DELETE request to the CountryAbsences#destroy action" do
     
          before { delete country_absence_path(country_absence) }
          specify { response.should redirect_to(root_path) }        
        end
    
      end
    
      describe "submitting a PUT request to the CountryAbsences#update action" do
       
        before { put country_absence_path(country_absence) }
        specify { response.should redirect_to(root_path) }
      end
    
    end
    
  end
  
  describe "when logged in as admin" do
    
    before do
      admin = FactoryGirl.create(:admin, name: "An Admin", email: "anadmin@example.com")
      sign_in admin
    end
    
    describe "AbsenceTypes controller" do
    
      describe "index" do
      
        before do  
          @absence_2 = AbsenceType.create(absence_code: "AB", paid: 0, notes: "Absence - no reason given")
          @absence_3 = AbsenceType.create(absence_code: "S50", paid: 50, sickness: true,
          								maximum_days_year: 15, documentation_required: true, notes: "Sickness on half-pay")
          visit absence_types_path
        end
      
        it { should have_selector('title', text: 'Absence Types') }
        it { should have_selector('h1', text: 'Absence Types') }
        it { should_not have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        
        describe "list " do
      
          it { should have_link('edit', href: edit_absence_type_path(@absence)) }
          it { should have_link('del', href: absence_type_path(@absence)) }
          it { should have_link('Add', href: new_absence_type_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'UL') }  #allows for table header
          it { should_not have_selector('.recent', text: "*") }
        
          it "should delete absence_type" do
            expect { click_link('del') }.to change(AbsenceType, :count).by(-1)
          end
          
        end
      end
      
      describe "new" do
      
        before { visit new_absence_type_path }
      
        it { should have_selector('title', text: 'New Absence Type') }
        it { should have_selector('h1',    text: 'New Absence Type') }
        it { should have_link('Absence-types list', href: absence_types_path) }
    
        describe "creating a new absence type" do
      
          before do
            fill_in "Absence code",  with: "BT"
            fill_in "paid", 				 with: 100
            fill_in "Notes",				 with: "Business trip"
          end
          
          it "should create an absence type" do
            expect { click_button "Create" }.to change(AbsenceType, :count).by(1)
            page.should have_selector('h1', text: 'Absence Types')
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Absence code",  with: "" }
        
          it "should not create an absence type" do
            expect { click_button "Create" }.not_to change(AbsenceType, :count)
            page.should have_selector('h1', text: 'New Absence Type')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit" do
    
        before do
          @absence_3 = AbsenceType.create(absence_code: "WL", maximum_days_year: 3, notes: "Wedding Leave - once in employment")
          visit edit_absence_type_path(@absence_3)
        end
    
        it { should have_selector('title', text: 'Edit Absence Type') }
        it { should have_selector('h1',    text: 'Edit Absence Type') }
        it { should have_selector('input', value: @absence_3.absence_code) }
        it { should have_link('Back', href: absence_types_path) }
    
        describe "with invalid data" do
          before do
            fill_in 'Absence code', with: " "
            click_button "Save changes"
          end
        
          it { should have_selector('title', text: 'Edit Absence Type') }
          it { should have_content('error') }
          specify { @absence_3.reload.absence_code.should == 'WL' }
        end
      
        describe "with valid data" do
      
          let(:new_absence) { "ML" }
          before do
            fill_in 'Absence code', with: new_absence
            click_button "Save changes" 
          end
      
          it { should have_selector('title', text: 'Absence Types') }
          it { should have_selector('div.alert.alert-success') }
          specify { @absence_3.reload.absence_code.should == new_absence }
        end
      end
    end
    
    describe "CountryAbsences controller" do
    
      before do
        @nationality = FactoryGirl.create(:nationality, nationality: "German")
        @currency = FactoryGirl.create(:currency, currency: "Mark", code: "DM")
        @country = FactoryGirl.create(:country, country: "Germany", nationality_id: @nationality.id, currency_id: @currency.id)
      end 
        
      describe "add a new absence-type for the country" do
      
        before { visit new_country_country_absence_path(@country.id) }
        
        it { should have_selector('title', text: 'New Absence Type') }
        it { should have_selector('h1', text: 'New Absence Type') }
        it { should have_selector('h1', text: @country.country) }
        it { should have_link('All absence types', href: country_country_absences_path(@country)) }
        it { should have_link('Set-up page', href: country_path(@country)) }
      
        describe "with valid data" do
        
          before do        
            fill_in "Absence code", with: "WL"
            fill_in "Notes", with: "Wedding Leave"
          end
          
          it "should create a new absence type for the country" do
            expect { click_button "Create" }.to change(CountryAbsence, :count).by(1)
            page.should have_selector('h1', text: 'Absence Types')
            page.should have_selector('h1', text: @country.country)
            page.should have_selector('title', text: "Absence Types: #{@country.country}")
          end 
        end
        
        describe "with invalid data" do
          
          before do
            fill_in "Absence code", with: "  "
          end
          
          it "should not create a new absence type for the country" do
            expect { click_button "Create" }.not_to change(CountryAbsence, :count)
            page.should have_selector('h1', text: 'New Absence Type')
            page.should have_selector('h1', text: @country.country)
            page.should have_content('error')    
          end
        end
      end
      
      describe "index of absences for country" do
      
        before { visit country_country_absences_path(@country) }
        
        it { should have_selector('h1', text: @country.country) }
        it { should have_selector('title', text: "Absence Types: #{@country.country}") }
        it { should have_selector('h1', text: 'Absence Types') }
        it { should have_link('Add an absence type', href: new_country_country_absence_path(@country)) }
        it { should have_link('Back to set-up page', href: country_path(@country)) }
        it { should have_link('edit', href: edit_country_absence_path(@country.country_absences.first)) }
        it { should have_link('del', href: country_absence_path(@country.country_absences.first)) }
        it { should_not have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        it { should_not have_selector('.recent', text: "*") }
        
        describe "editing an absence in the correct country" do
          before { click_link 'edit' }
          
          it { should have_selector('title', text: "Edit Absence Type") }
          it { should have_selector('h1', text: @country.country) }
        
        end
        
        describe "deleting an absence" do
        
          it "should be from the correct model" do
            expect { click_link('del') }.to change(CountryAbsence, :count).by(-1)
          end
        end
      end
      
      describe "editing one of the country's absences" do
      
        let(:country_absence) { CountryAbsence.find_by_country_id_and_absence_code(@country.id, @absence.absence_code) }
        before { visit edit_country_absence_path(country_absence) }
        
        it { should have_selector('h1', text: @country.country) }
        it { should have_selector('title', text: "Edit Absence Type") }
        it { should have_selector('h1', text: 'Edit Absence Type') }
        it { should have_link('All absence types', href: country_country_absences_path(@country)) }
        it { should have_link('Set-up page', href: country_path(@country)) }      
      
        describe "updating with valid data" do
          
          before do
            fill_in "Absence code", with: "AB"
            fill_in "Notes", with: "Unspecified absence"
            click_button "Save changes"
          end
          
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: "Absence Types: #{@country.country}") }
          it { should have_selector('h1', text: 'Absence Types') }
          #it { should have_selector('title', text: 'Edit Absence Type') }
          #it { should have_content('error') }
          specify { country_absence.reload.absence_code.should == 'AB' }    
                 
        end
        
        describe "updating with invalid data" do
        
          before do
            fill_in "Absence code", with: " "
            click_button "Save changes"
          end
          
          it { should have_selector('h1', text: @country.country) }
          it { should have_selector('title', text: 'Edit Absence Type') }
          it { should have_content('error') }
          specify { country_absence.reload.absence_code.should == "UL" }   
        end
      end 
    end
  end
  
  describe "when logged in as superuser" do
  
    before do
      superuser = FactoryGirl.create(:superuser, name: "S User", email: "suser@example.com")
      sign_in superuser 
    end
  
    describe "AbsenceTypes controller" do
    
      describe "index" do
      
        before do  
          @absence_2 = AbsenceType.create(absence_code: "AB", paid: 0, notes: "Absence - no reason given")
          @absence_3 = AbsenceType.create(absence_code: "S50", paid: 50, sickness: true,
          								maximum_days_year: 15, documentation_required: true, notes: "Sickness on half-pay")
          visit absence_types_path
        end
      
        it { should have_selector('#recent-adds', text: "added in past 7 days") }
        it { should have_selector('.recent', text: "*") }
        
      end
    end
    
    describe "CountryAbsences controller" do
    
      before do
        @nationality = FactoryGirl.create(:nationality, nationality: "German")
        @currency = FactoryGirl.create(:currency, currency: "Mark", code: "DM")
        @country = FactoryGirl.create(:country, country: "Germany", nationality_id: @nationality.id, currency_id: @currency.id)
      end
      
      describe "index of absences for country" do
      
        before { visit country_country_absences_path(@country) } 
      
        it { should have_selector('#recent-adds', text: "additions (*) in past 7 days") }
        it { should have_selector('.recent', text: "*") }
      end
    end
  end 
end
