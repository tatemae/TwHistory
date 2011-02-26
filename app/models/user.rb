class User < ActiveRecord::Base
  acts_as_tagger
  include MuckInvites::Models::MuckInviter
  include MuckShares::Models::MuckSharer
  include MuckFriends::Models::MuckUser
  include MuckProfiles::Models::MuckUser
  include MuckUsers::Models::MuckUser
  
  has_many :projects
  has_many :project_roles
  has_many :authorized_projects, :through => :project_roles, :source => 'project'
  
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
  
  # Determines which users can add content directly to the site via muck-contents.
  def can_add_root_content?
    admin?
  end
  
  def can_upload?(check_user)
    admin?
  end
  
end
