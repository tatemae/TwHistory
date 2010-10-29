class User < ActiveRecord::Base
  acts_as_tagger
  include MuckInvites::Models::MuckInviter
  include MuckShares::Models::MuckSharer
  include MuckFriends::Models::MuckUser
  include MuckProfiles::Models::MuckUser
  include MuckUsers::Models::MuckUser
  
  has_many :projects
  has_many :project_roles
  has_many :authorized_projects, :class_name => 'Project', :through => :project_roles
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  
    
  has_friendly_id :login

  def short_name
    self.first_name || login
  end
  
  def full_name
    if self.first_name.blank? && self.last_name.blank?
      self.login rescue 'Deleted user'
    else
      ((self.first_name || '') + ' ' + (self.last_name || '')).strip
    end
  end

  def display_name
    self.login
  end
  
end
