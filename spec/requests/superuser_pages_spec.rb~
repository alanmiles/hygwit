require 'spec_helper'

describe "SuperuserPages" do
  
  subject { page }

  before do
    @nationality = FactoryGirl.create(:nationality, nationality: 'French') 
    @currency = Currency.create(currency: 'Euro', code: 'EUR')
    @country = Country.create(country: "France", currency_id: @currency.id, nationality_id: @nationality.id)
    @admin = FactoryGirl.create(:admin, name: "Admin Person", email: "adminperson@example.com")
  end
  
  describe "when not logged in" do
    
    describe "CountryAdmins controller" do
    
      describe "adding a new record" do
      
        before { visit new_country_admin_path }
        
        it "should render the root path" do
          page.should have_selector('.alert', text: 'You must be a HROomph superuser')
          page.should have_selector('h2', text: 'Achievement-flavored HR') 
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_admins_path }
      
        it "should render the root path" do
          page.should have_selector('.alert', text: 'You must be a HROomph superuser')
          page.should have_selector('h2', text: 'Achievement-flavored HR') 
        end
      end
      
      describe "when trying to change the country_admin data" do
      
        before do      
          @c_admin = FactoryGirl.create(:country_admin, user_id: @admin.id, country_id: @country.id)
        end
        
        describe "with a PUT request" do
          before { put country_admin_path(@c_admin) }
          specify { response.should redirect_to(root_path) }
        end
      
        describe "with a DELETE request" do
          before { delete country_admin_path(@c_admin) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
  end
  
  describe "when logged in as non-superuser" do
  
    before { sign_in(@admin) }
  
    describe "CountryAdmins controller" do
    
      describe "adding a new record" do
      
        before { visit new_country_admin_path }
        
        it "should render the user menu" do
          page.should have_selector('.alert', text: 'You must be a HROomph superuser')
          page.should have_selector('h1', text: @admin.name) 
        end
      end
    
      describe "when trying to access the index" do
    
        before { visit country_admins_path }
      
        it "should render the user path" do
          page.should have_selector('.alert', text: 'You must be a HROomph superuser')
          page.should have_selector('h1', text: @admin.name)
        end
      end
      
      describe "when trying to change the country_admin data" do
      
        before do      
          @c_admin = FactoryGirl.create(:country_admin, user_id: @admin.id, country_id: @country.id)
        end
        
        describe "with a PUT request" do
          before { put country_admin_path(@c_admin) }
          specify { response.should redirect_to(user_path(@admin)) }
        end
      
        describe "with a DELETE request" do
          before { delete country_admin_path(@c_admin) }
          specify { response.should redirect_to(user_path(@admin)) }        
        end
      end
    end  
  end
  
  describe "when logged in as superuser" do
  
    before do
      @admin_2 = FactoryGirl.create(:admin, name: "Another", email: "admin99@example.com")
      @superuser = FactoryGirl.create(:superuser, name: "Super User", email: "superuser@example.com")
      sign_in(@superuser)
    end
    
    describe "CountryAdmins controller" do
    
      describe "adding a new record" do
      
        before { visit new_country_admin_path }
        
        it { should have_selector('h1', text: "New Country Administrator") }
        it { should have_selector('title', text: "New Country Administrator") }
        it { should have_link('List', href: country_admins_path) }
      
        describe "creating a new record" do
          describe "with valid information" do
          
            before do
              select @country.country,  from: "Country"
              select @admin_2.name, from: "User"
            end
            
            it "should create a country admin and redirect to the 'index' page" do
              expect { click_button "Create" }.to change(CountryAdmin, :count).by(1)
              page.should have_selector('h1', text: 'Country Administrators')
            end 
          end
          
          describe "with invalid information" do
            
            before { select @admin_2.name, from: "country_admin_user_id" }
            
            it "should not create a country admin" do
              expect { click_button "Create" }.not_to change(CountryAdmin, :count)
              page.should have_selector('h1', text: 'New Country Administrator')
              page.should have_content('error')
            end
          end
        end
      
      end
    end
  end
end
