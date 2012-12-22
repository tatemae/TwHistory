module TwitterMethods

  def client
    return nil unless self.authentication
    Twitter::Client.new({
      :consumer_key    => ::Secrets.auth_credentials['twitter']['key'],
      :consumer_secret => ::Secrets.auth_credentials['twitter']['secret'],
      :access_key      => self.authentication.token,
      :access_secret   => self.authentication.secret
    })
  end

end