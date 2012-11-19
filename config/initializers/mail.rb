ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'app8810110@heroku.com',
  :password       => '7iwcosdx',
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}
ActionMailer::Base.delivery_method = :smtp


