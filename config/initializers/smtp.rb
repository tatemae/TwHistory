unless Rails.env.test? # we don't want tests attempting to send out email
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => MuckEngine.configuration.email_server_address,
    :port => 25,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => Secrets.email_user_name,
    :password => Secrets.email_password,
    :domain => MuckEngine.configuration.base_domain
  }
  # ActionMailer::Base.smtp_settings = {
  #   :address => "smtp.gmail.com",
  #   :port => 587,
  #   :authentication => :plain,
  #   :enable_starttls_auto => true,
  #   :user_name => Secrets.email_user_name,
  #   :password => Secrets.email_password,
  #   :domain => MuckEngine.configuration.base_domain
  # }
end

ActionMailer::Base.default_url_options[:host] = MuckEngine.configuration.application_url
