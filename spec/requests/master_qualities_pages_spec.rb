require 'spec_helper'

describe "MasterQualitiesPages" do
  
  subject { page }
  
  before do
    @quality = Quality.create(quality: 'Punctuality', created_by: 1)
  end
  
  describe "when not logged in" do
    
    describe "qualities controller" do
    
      before { visit new_quality_path }
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    
      describe "when trying to access the index" do
    
        before { visit qualities_path }
      
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to access the 'show' page" do
      
        before { visit quality_path(@quality) }
        
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to access the 'edit' page" do
        
        before { visit edit_quality_path(@quality) }
        
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to update or delete" do
        
        describe "with a PUT request" do
          before { put quality_path(@quality) }
          specify { response.should redirect_to(signin_path) }
        end
      
        describe "with a DELETE request" do
          before { delete quality_path(@quality) }
          specify { response.should redirect_to(signin_path) }        
        end
      end
    end
    
    describe "descriptors controller" do
    
      let(:des) { Descriptor.find_by_quality_id_and_grade(@quality.id, "A") }
      
      describe "when trying to access the 'edit' page" do
        
        before { visit edit_descriptor_path(des) }
        
        it "should render the sign-in path" do
          page.should have_selector('.alert', text: 'sign in')
          page.should have_selector('h1', text: 'Sign in')
        end
      end
      
      describe "when trying to update" do
        
        describe "with a PUT request" do
          before { put descriptor_path(des) }
          specify { response.should redirect_to(signin_path) }
        end
      end
       
    end
  end
  
  describe "when logged in as non-admin" do
  
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    
    describe "qualities controller" do
    
      describe "when trying to access the index" do
        
        before { visit qualities_path }
      
        it "should render the root-path" do
          page.should have_selector('.alert', text: 'You must be a HROomph admin')
          page.should have_selector('h2', text: 'Achievement-flavored HR')
        end
      end
      
      describe "adding a new quality successfully" do
        pending("this should be fine but should be unapproved")
        pending("no return to list button")
      end
      
      describe "editing a quality" do
        pending("this should be possible only for non-approved entries added by the user")
        pending("no return to list button")
      end
      
      describe "deleting a quality" do
        pending("this should be possible only for non-approved entries added by the user")
      end
      
    end
    
    describe "descriptors controller" do
    
      pending("tests for signed in non-admin")
      
    end
  end
  
  describe "when logged in as admin" do
  
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    
    describe "qualities controller" do
    
      describe "index" do
      
        before do  
          @quality = Quality.create(quality: 'Care for the workplace', created_by: 1)
          @quality_2 = Quality.create(quality: 'Teamwork', created_by: 1)
          @quality_3 = Quality.create(quality: 'Attendance', created_by: 1)
          visit qualities_path
        end
      
        it { should have_selector('title', text: 'Personal Qualities') }
        it { should have_selector('h1', text: 'Personal Qualities') }
      
        describe "list " do
      
          it { should have_link('change', href: quality_path(@quality)) }
          it { should have_link('delete', href: quality_path(@quality)) }
          it { should have_link('Add', href: new_quality_path) }
          it { should have_selector('ul.itemlist li:nth-child(4)', text: 'Teamwork') }
        
          describe "quality already in use" do
        
            it "should not have 'Delete' button"
          end
        
          it "should be able to delete a quality" do
            expect { click_link('delete') }.to change(Quality, :count).by(-1)
          end
          
          it "should remove all related descriptors simultaneously" do
            expect { click_link('delete') }.to change(Descriptor, :count).by(-5)
          end
          
          describe "when > 10 qualities" do
            pending("should have a bottom 'Add button + not when < 10 entries") 
          end
       
        end
      end
      
      describe "the 'show' page" do
      
        before do  
          @quality = Quality.create(quality: 'Leadership', created_by: 1)
          @descriptor = Descriptor.find_by_quality_id_and_grade(@quality.id, "A")
          visit quality_path(@quality)
        end
      
        it { should have_selector('title', text: 'Leadership') }
        it { should have_selector('h1', text: 'Leadership') }
        it { should have_link('Edit', href: edit_quality_path(@quality)) }
        it { should have_link('Qualities list', href: qualities_path) }
        it { should have_link('change', href: edit_descriptor_path(@descriptor)) }
      end
      
      describe "editing a descriptor" do
      
        before do  
          @quality = Quality.create(quality: 'Initiative', created_by: 1)
          @descriptor = Descriptor.find_by_quality_id_and_grade(@quality.id, "A")
          visit edit_descriptor_path(@descriptor)
        end
        
        it { should have_selector('title', text: 'Edit Descriptor') }
        it { should have_selector('h1', text: @quality.quality) }
        it { should have_selector('h3', text: "Edit Descriptor A") }
        it { should have_link('Back', href: quality_path(@quality)) }
        
        describe "with an incorrect entry" do
          
          before do
            fill_in "descriptor[descriptor]", with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Descriptor') }
          it { should have_content('error') }
        end
        
        describe "with a correct entry" do
        
          before do
            fill_in "descriptor[descriptor]", with: "A description of the A grade for Initiative"
            click_button "Save change"
          end
          
          it { should have_selector('title', text: @quality.quality) }
          it { should have_link('Qualities list', href: qualities_path) }
          specify { @descriptor.reload.reviewed.should == false }
          specify { @descriptor.reload.updated_by.should == admin.id }
        end
        
      end
    
      describe "accessing the 'new' page" do
    
        before { visit new_quality_path }
      
        it { should have_selector('title', text: 'New Quality') }
        it { should have_selector('h1',    text: 'New Quality') }
        it { should have_link('Back', href: qualities_path) }
        it { should have_selector('#approving', value: '1', input_checked: 'checked') }
    
        describe "creating a new quality" do
      
          before { fill_in "Quality",  with: "Courage" }
        
          it "should create a quality" do
            expect { click_button "Create" }.to change(Quality, :count).by(1)
            page.should have_selector('h1', text: 'Courage')
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Quality",  with: "" }
        
          it "should not create a quality" do
            expect { click_button "Create" }.not_to change(Quality, :count)
            page.should have_selector('h1', text: 'New Quality')
            page.should have_content('error')
          end  
      
        end
      end
    
      describe "edit" do
    
        before do
          @quality_3 = Quality.create(quality: 'Leadership', created_by: 1)
          visit edit_quality_path(@quality_3)
        end
    
        it { should have_selector('title', text: 'Edit Quality') }
        it { should have_selector('h1',    text: 'Edit Quality') }
        it { should have_selector('input', value: @quality_3.quality) }
        it { should have_selector('#approving', type: 'checkbox') }
        it { should have_link('Back', href: quality_path(@quality_3)) }
    
        describe "with invalid data" do
          before do
            fill_in 'Quality', with: " "
            click_button "Save change"
          end
        
          it { should have_selector('title', text: 'Edit Quality') }
          it { should have_content('error') }
          specify { @quality_3.reload.quality.should == 'Leadership' }
        end
      
        describe "with valid data" do
      
          let(:new_quality) { "Judgement" }
          before do
            fill_in 'Quality', with: new_quality
            check 'Approved'
            click_button "Save change"
          end
      
          it { should have_selector('title', text: 'Judgement') }
          it { should have_selector('div.alert.alert-success') }
          it { should have_selector('#item-A', text: 'Descriptor for A') }
          specify { @quality_3.reload.quality.should == new_quality }
          specify { @quality_3.reload.approved.should == true }
        end
      end 
    end
  end 
end