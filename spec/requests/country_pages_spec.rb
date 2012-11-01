require 'spec_helper'

describe "CountryPages" do
  
  subject { page }
  
  before { @example = FactoryGirl.create(:nationality, nationality: 'Omani') }
  
  describe "when not logged in" do
    
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
  
  describe "when logged in as non-admin" do
  
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    
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
  
  describe "when logged in as admin" do
    
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    
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
       
      end
    end
    
    describe "accessing the 'new' page" do
    
      before { visit new_nationality_path }
      
      it { should have_selector('title', text: 'New nationality') }
      it { should have_selector('h1',    text: 'New nationality') }
    
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
          page.should have_selector('h1', text: 'New nationality')
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
end
