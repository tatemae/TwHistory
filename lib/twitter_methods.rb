module TwitterMethods

  def client
    return nil unless self.authentication
    oauth.authorize_from_access(self.authentication.token, self.authentication.secret)
    Twitter::Base.new(oauth)
  end

  def oauth
    @oauth ||= Twitter::OAuth.new(::Secrets.auth_credentials['twitter']['key'], ::Secrets.auth_credentials['twitter']['secret'], :sign_in => true)
  end
  
end