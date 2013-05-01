require 'spec_helper'

describe "User pages" do

  subject { page }
  
  describe "index" do
    
    describe "not signed in" do
      before { visit users_path }

      it "should render the signin page" do
        page.should_not have_selector('title', text: 'All users')
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
          
    end
    
    describe "sign in as non-HR2.0 admin" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
        visit users_path
      end
    
      it "should deny access and return to the home page" do
        page.should_not have_selector('title', text: 'All users')
        page.should_not have_selector('h1',    text: 'All users')
        page.should have_selector('.alert', text: 'You must be a HROomph admin')
        page.should have_selector('h1', text: 'User Home Page')
      end
    end
    
    
    describe "sign in as HR2.0 admin" do
      before(:each) do
        @admin = FactoryGirl.create(:admin)
        sign_in @admin
        visit users_path
      end

      it { should have_selector('title', text: 'All users') }
      it { should have_selector('h1',    text: 'All users') }

      describe "pagination" do

        before(:all) { 30.times { FactoryGirl.create(:user) } }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each user" do
          User.paginate(page: 1).each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
        
        describe "delete links" do
          it { should have_link('delete', href: user_path(User.first)) }
          it "should be able to delete another user" do
            expect { click_link('delete') }.to change(User, :count).by(-1)
          end
          it { should_not have_link('delete', href: user_path(@admin)) }
        end
      end        
    end
  end

  describe "show" do
  
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
  
    describe "not signed in" do
    
      before { visit user_path(@user) }
      
      it "should render the signin page" do
        page.should have_selector('.alert', text: 'Please sign in')
        page.should have_selector('h1', text: 'Sign in') 
      end
    end
    
    describe "signed in" do
    
      before { sign_in @user }
      
      describe "when not a business administrator" do
      
        before { visit user_path(@user) }
        
        it { should have_selector('h1', text: 'User Home Page') } 
        it { should have_selector('h1', text: @user.name) } 
        it { should_not have_selector('li', text: "Work as an ADMINISTRATOR") }
        it { should have_link("Set up a new HR2", href: new_business_path) }
      end
      
      describe "when a business administrator" do
      
        before do
          @country = FactoryGirl.create(:country, complete: true)
          @sector = FactoryGirl.create(:sector, checked: true)
          @business = FactoryGirl.create(:business, country_id: @country.id, sector_id: @sector.id, created_by: @user.id)
          @business_admin = FactoryGirl.create(:business_admin, business_id: @business.id, user_id: @user.id, created_by: @user.id)
          visit user_path(@user)
        end
        
        it { should have_selector('h1', text: 'User Home Page') } 
        it { should have_selector('li', text: "Work as an ADMINISTRATOR") }
        it { should have_link("#{@business.name}", href: business_path(@business)) }
        it { should have_link("Set up a new HR2", href: new_business_path) }
      end     
    end
  end
  
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end
  
  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before do
        fill_in "Name",             with: "John"
        fill_in "Email",            with: "john@example.com"
        fill_in "Password",         with: "johnpass"
        click_button "Save changes"
      end

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
    
  end
  
  describe "trying to work with data that doesn't belong to current user" do
  
    before do
      @user = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user, name: "B User", email: "buser@example.com", password: "barbuzz",
          						password_confirmation: "barbuzz", remember_token: "23456")
      sign_in @user
      
    end
    
    describe "User#show page" do
      
      before { visit user_path(@user_2) }
              
      it "should deny access" do
        page.should have_selector('h1', text: 'User Home Page')
        page.should have_selector('h1', text: @user.name)
        page.should_not have_selector('h1', text: @user_2.name)
      end  
    end
    
    describe "User#edit page" do
    
      before { visit edit_user_path(@user_2) }
    
      it "should deny access" do
        page.should_not have_selector('h1',    text: "Update your profile")
        page.should_not have_selector('title', text: "Edit User")
        page.should have_selector('h1',				 text: "User Home Page")
        page.should have_selector('h1',				 text: @user.name)
      end   
    end
    
    describe "User#put requests" do
          
      before { put user_path(@user_2) }
      specify { response.should redirect_to(root_path) }
    end
      
    describe "User#delete requests" do

      before do
        delete user_path(@user_2)
      end 
      
      specify { response.should redirect_to user_path(@user) }
      #@cnt = User.count
      #@cnt.should == 2    
    end
  end
end
