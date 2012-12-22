Twitter.configure do |config|
  config.consumer_key = ::Secrets.auth_credentials['twitter']['key']
  config.consumer_secret = ::Secrets.auth_credentials['twitter']['secret']
end