require 'spec_helper'

describe "BusinessSetups" do
  subject { page }
  
  describe "when not logged in" do
    
    before do
      @business = FactoryGirl.create(:business, created_by: 1)
    end
    
    describe "create a new business" do
      before { visit new_business_path }
      it "should render the signin page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
  end
  
  describe "when logged in" do
  
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      @country = FactoryGirl.create(:country, complete: true)
      @incomplete_country = @country.dup
      @incomplete_country.country = "Country_2"
      @incomplete_country.complete = false
      @incomplete_country.save
      @sector = FactoryGirl.create(:sector, checked: true)
      @unchecked_sector = @sector.dup
      @unchecked_sector.sector = "Sector 2"
      @unchecked_sector.checked = false
      @unchecked_sector.save
      @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: user.id)  
      sign_in user   
    end
    
    describe "create a new business" do
      before { visit new_business_path }
      
      describe "viewing the new business page" do
        it { should have_selector('h1', text: "Set Up A New Business") }
        it { should have_selector('title', text: "New Business") }
        it { should have_selector('option', text: @country.country) }
        it { should_not have_selector('option', text: @incomplete_country.country) }
        it { should have_selector('option', text: @sector.sector) }
        it { should_not have_selector('option', text: @unchecked_sector.sector) }
        it { should have_selector('input#business_name') }
        it { should have_selector('input#business_address_1') }  
        it { should have_selector('input#business_address_2') }
        it { should have_selector('input#business_city') } 
        it { should have_selector('input#business_created_by', value: user.id.to_s) }
        it { should have_link('Cancel', href: user_path(user)) } 
      end
    
      describe "add invalid data" do
      
        before { fill_in :name, with: " " }
        
        it "should not create a business" do
          expect { click_button "Create" }.not_to change(Business, :count)
          page.should have_selector('h1', text: 'Set Up A New Business')
          page.should have_content('error')
        end
        
      end
      
      describe "add valid data" do
      
        before do
          @business_count = Business.count
          @bus_admin_count = BusinessAdmin.count
          fill_in "business_name", with: "Foo Ltd"
          fill_in :created_by, with: 1
          select "Qatar", from: "business[country_id]"
          select @sector.sector, from: "business[sector_id]"
          click_button "Create"
        end
        
        it "should create a new business + BusinessAdmin record" do
          @new_business_count = Business.count
          @new_business_count.should == @business_count + 1
          @new_bus_admin_count = BusinessAdmin.count
          @new_bus_admin_count.should == @bus_admin_count + 1
          page.should have_selector('h1', text: 'Your Business Settings')
        end
        
      end
    end
  end
end
