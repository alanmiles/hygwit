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
  end
  
  describe "when logged in as non-admin" do
  
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    
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
  end
  
  describe "when logged in as admin" do
    
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    
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
      
        describe "list " do
      
          it { should have_link('edit', href: edit_absence_type_path(@absence)) }
          it { should have_link('del', href: absence_type_path(@absence)) }
          it { should have_link('Add', href: new_absence_type_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'UL') }  #allows for table header
        
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
  end 
end
