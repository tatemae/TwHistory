module TwitterMethods

  def client
    return nil unless self.authentication
    oauth.authorize_from_access(self.authentication.token, self.authentication.secret)
    Twitter::Base.new(oauth)
  end

  def oauth
    @oauth ||= Twitter::OAuth.new(::Secrets.auth_credentials['twitter']['key'], ::Secrets.auth_credentials['twitter']['secret'], :sign_in => true)
  end
  
  # TODO this is for the future version of the twitter gem
  # def client
  #   return nil unless self.authentication
  #   oauth = {
  #     :consumer_key    => ::Secrets.auth_credentials['twitter']['key'],
  #     :consumer_secret => ::Secrets.auth_credentials['twitter']['secret'],
  #     :access_key      => self.authentication.token,
  #     :access_secret   => self.authentication.secret
  #   }
  #   Twitter::Authenticated.new(oauth)
  # end
  
end