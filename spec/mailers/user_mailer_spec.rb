require "spec_helper"

describe UserMailer do
  
  before do
    @forgetful = FactoryGirl.create(:user, name: "Forgetful User", email: "forgetful@example.com")
  end
    
  describe "Password Reset" do
  
    #before do 
    #  @mail = UserMailer.password_reset(@forgetful) 
    #end
  

    it "should be set to be delivered to the email passed in" do
      pending("Non-restful route because calling remember-token id.  Need tests")
       #@mail.should deliver_to("forgetful@example.com")
    end

  #it "should contain the user's message in the mail body" do
   #it.should have_body_text(/To reset your password/)
  #end

  #it "should contain a link to the confirmation link" do
  #  @email.should have_body_text(/#{confirm_account_url}/)
  #end

  #it "should have the correct subject" do
    #it.should have_subject(/Password Reset/)
  #end
    #pending("development")
	end
  
end

