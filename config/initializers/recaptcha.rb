if MuckUsers.configuration.use_recaptcha
  ENV['RECAPTCHA_PUBLIC_KEY'] = Secrets.recaptcha_pub_key
  ENV['RECAPTCHA_PRIVATE_KEY'] = Secrets.recaptcha_priv_key
end