
#
# Replace twhistory.com in this file with your website's domain name
#
  
MuckEngine.configure do |config|

  # Environment sensitive values
  if Rails.env.production?
    config.application_url = 'www.twhistory.com'     # Url of the application in production
  elsif Rails.env.staging?
    config.application_url = 'www.twhistory.com'     # Url of the application on staging
  else
    config.application_url = 'localhost:3000'         # Url of the application for test or development
  end
  
  # Global application values.  These are used to display the app name, send emails, and configure where system emails go.
  config.application_name = 'TwHistory'       # Common name for your application.  i.e. My App, Billy Bob, etc
  config.from_email = 'support@twhistory.com'  # Emails will come from this address i.e. noreply@example.com, support@example.com, system@example.com, etc
  config.from_email_name = 'TODO Name'          # This will show up as the name on emails.  i.e. support@example.com <Example>
  config.support_email = 'support@twhistory.com'  # Support email for your application.  This is used for contact us etc.
  config.admin_email = 'admin@twhistory.com'      # Admin email for your application
  config.customer_service_number = '1-800-'     # Phone number if you have one (optional)

  # Email charset.  No need to change this unless you have a good reason to change the encoding.
  config.mail_charset = 'utf-8'

  # Application settings
  config.local_jquery = false         # If true jquery will be loaded from the local directory. If false then it will be loaded from Google's CDN
  config.growl_enabled = false        # If true then notifications and errors will popup in an overlay div similar to 'growl' on the mac. This uses jGrowl which must be included in your layout

  # Email server configuration
  # Sendgrid is easy: https://sendgrid.com/user/signup
  config.email_server_address = "smtp.sendgrid.net"    # Email server address.  'smtp.sendgrid.net' works for sendgrid
  config.email_user_name = Secrets.email_user_name    # Email server username
  config.email_password = Secrets.email_password      # Email server password
  config.base_domain = 'twhistory.com'                # Basedomain that emails will come from

  # ssl
  config.enable_ssl = false # Enable ssl if you have an ssl certificate installed.  This will provide security between the client and server.

  # Google Analtyics Configuration.  This will enable Google Analytics on your site and will be used if your template includes:
  #                                  <%= render :partial => 'layouts/global/google_analytics' %>
  config.google_tracking_code = ""                     # Get a tracking code here: http://www.google.com/analytics/. The codes look like this: 'UA-9685000-0'
  config.google_tracking_set_domain = "twhistory.com" # Base domain provided to Google Analytics. Useful if you are using subdomains but want all traffic 
                                              # recorded into one account.
end
  
MuckUsers.configure do |config|

  # sign up options
  config.automatically_activate = true                    # Automatically active a users account during registration. If true the user won't get a 
                                                          # 'confirm account' email. If false then the user will need to confirm their account via an email.
  config.automatically_login_after_account_create = true  # Automatically log the user in after they have setup their account. This should be false if you 
                                                          # require them to activate their account.
  config.send_welcome = true                              # Send out a welcome email after the user has signed up.

  # if you use recaptcha you will need to also provide a public and private key available from http://recaptcha.net.
  config.use_recaptcha = false      # This will turn on recaptcha during registration. This is an alternative to sending the 
                                    # user a confirm email and can help reduce spam registrations.

  config.let_users_delete_their_account = false   # Turn on/off ability for users to delete their own account. It is not recommended that you let 
                                                  # users delete their own accounts since the delete can cascade through the system with unknown results.
end
  
