class Authentication < ActiveRecord::Base
  belongs_to :authenticatable, :polymorphic => true
  validates_presence_of :provider
  validates_presence_of :uid
  validates_presence_of :name
  validates_presence_of :nickname
  validates_presence_of :token
  validates_presence_of :secret
  
  after_create :update_parent_twitter_profile
  
  def update_parent_twitter_profile
    self.authenticatable.twitter_update if self.authenticatable
  end
  
end
