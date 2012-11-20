class UserMailer < ActionMailer::Base
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  default :from => "alanpqs@gmail.com"
  
  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "HR2.0 Password Reset")
  end
end
