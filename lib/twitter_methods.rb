module TwitterMethods

  def client
    return nil unless self.authentication
    Twitter::Client.new({
      :oauth_token          => self.authentication.token,
      :oauth_token_secret   => self.authentication.secret
    })
  end

end