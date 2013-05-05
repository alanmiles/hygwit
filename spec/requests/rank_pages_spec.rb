require 'spec_helper'

describe "RankPages" do
  
  subject { page }
  
  before do
    @user = FactoryGirl.create(:user)
    @country = FactoryGirl.create(:country, created_by: 1, checked: true)
    @sector = FactoryGirl.create(:sector, created_by: 1, checked: true)
    @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
    @rank_cat = @business.rank_cats.create(rank: "Management")
  end
  
  describe "not logged in" do
  
    describe "index page" do
      
      before { visit business_job_ranks_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "new page" do
      
      before { visit new_business_job_rank_path(@business) }
      
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
      
    describe "edit page" do
      
      before do 
        visit edit_job_rank_path(@rank_cat)
      end
              
      it "should render the home page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "when trying to change the Rank_Cat data" do
      
      describe "with a PUT request" do
        before { put job_rank_path(@rank_cat) }
        specify { response.should redirect_to(root_path) }
      end
      
      describe "with a DELETE request" do
        before { delete job_rank_path(@rank_cat) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
  
  describe "logged in"do
  
    before { sign_in @user }
    
    describe "not business admin" do
    
      describe "index page" do
      
        before { visit business_job_ranks_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_job_rank_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_job_rank_path(@rank_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the Rank_Cat data" do
      
        describe "with a PUT request" do
          before { put job_rank_path(@rank_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete job_rank_path(@rank_cat) }
          specify { response.should redirect_to @user }        
        end
      end
    end
  
    describe "business admin, but without access to Settings" do
     
      before do
        @business_2 = FactoryGirl.create(:business, name: "Biz 2", country_id: @country.id, sector_id: 
        									@sector.id, created_by: @user.id)    
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business_2.id, user_id: @user.id, created_by: 1)
      end
      
      describe "index page" do
      
        before { visit business_job_ranks_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "new page" do
      
        before { visit new_business_job_rank_path(@business) }
      
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
      
      describe "edit page" do
      
        before do 
          visit edit_job_rank_path(@rank_cat)
        end
              
        it "should render the home page" do
          page.should have_selector('.alert', text: "Sorry, you're not a registered officer")
          page.should have_selector('h1', text: 'User Home Page') 
        end
      end
    
      describe "when trying to change the Job_Cat data" do
      
        describe "with a PUT request" do
          before { put job_rank_path(@rank_cat) }
          specify { response.should redirect_to @user }
        end
      
        describe "with a DELETE request" do
          before { delete job_rank_path(@rank_cat) }
          specify { response.should redirect_to @user }        
        end
      end
      
    end
  
    describe "business admin, with access to Settings" do
  
      before do
        @bizadmin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: 1)
        @jobfamily = FactoryGirl.create(:jobfamily, created_by: 1, checked: true)
        @division = @business.divisions.create(division: "Div") 
        @department = @business.departments.create(department: "Sales", dept_code: "SAL", 
        								division_id: @division.id)
        @job = @business.jobs.create(job_title: "Manager", department_id: @department.id, jobfamily_id: @jobfamily.id, 
        								rank_cat_id: @rank_cat.id, current: false)
        @rank_cat_2 = @business.rank_cats.create(rank: "Support")
      end
    
      describe "index page" do
      
        before { visit business_job_ranks_path(@business) }
      
        it { should have_selector('h1', text: 'Job Ranks') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector('li', text: @rank_cat.rank) }
        it { should have_selector('li', text: @rank_cat_2.rank) }
        it { should have_link('edit', href: edit_job_rank_path(@rank_cat)) }
        it { should have_link('edit', href: edit_job_rank_path(@rank_cat_2)) }
        it { should have_link('del', href: job_rank_path(@rank_cat_2)) }
        it { should have_link('Add a rank', href: new_business_job_rank_path(@business)) }
        it { should have_link('Back to Business Settings Menu', href: business_path(@business)) }
        
        
        describe "no delete link for ranks with a linked job, even if job not current" do
          it { should_not have_link('del', href: job_rank_path(@rank_cat)) }
        end
        
        it "should delete rank (when delete button is shown)" do
          expect { click_link('del') }.to change(@business.rank_cats, :count).by(-1)
        end
      end
      
      describe "new page" do
      
        before { visit new_business_job_rank_path(@business) }
      
        it { should have_selector('h1', text: 'New Rank') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#rank_cat_rank") }
        it { should have_link("Rank list", href: business_job_ranks_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "creating a new rank" do
      
          before { fill_in "Rank",  with: "Technical" }
        
          it "should create a rank" do
            expect { click_button "Create" }.to change(@business.rank_cats, :count).by(1)
            page.should have_selector('h1', text: "Ranks")
            page.should have_selector('h1', text: @business.name)
            page.should have_selector('div.alert.alert-success', text: "'Technical' has been added")
          end         
        end
      
        describe "creating a record that fails validation" do
      
          before { fill_in "Rank",  with: "" }
        
          it "should not create a Rank" do
            expect { click_button "Create" }.not_to change(RankCat, :count)
            page.should have_selector('h1', text: 'New Rank')
            page.should have_content('error')
          end  
      
        end
      
      end
      
      describe "edit page" do
      
        before { visit edit_job_rank_path(@rank_cat) }
      
        it { should have_selector('h1', text: 'Edit Rank') }
        it { should have_selector('h1', text: @business.name) }
        it { should have_selector("input#rank_cat_rank") }
        it { should have_link("Rank list", href: business_job_ranks_path(@business)) }
        it { should have_link("Business settings", href: business_path(@business)) }
      
        describe "editing the rank" do
      
          let(:new_rank) { "Office Staff" }
          before do
            fill_in 'Rank', with: new_rank
            click_button "Save change" 
          end
          
          it { should have_selector('title', text: 'Ranks') }
          it { should have_selector('div.alert.alert-success') }
          specify { @rank_cat.reload.rank.should == new_rank }
          specify { @rank_cat.reload.updated_by.should == @user.id }
               
        end
      
        describe "rank that fails validation" do
      
          let(:new_rank) { " " }
          before do
            fill_in 'Rank', with: new_rank
            click_button "Save change" 
          end
        
          it { should have_selector('title', text: 'Edit Rank') }
          it { should have_content('error') }
          specify { @rank_cat.reload.rank.should == @rank_cat.rank }
        end
      
      end
    end
  end
end
