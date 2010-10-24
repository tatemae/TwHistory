Secrets.auth_credentials.each_key do |key|
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider key, Secrets.auth_credentials[key]['key'], Secrets.auth_credentials[key]['secret']
  end  
end