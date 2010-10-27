class Character < ActiveRecord::Base
  include ::TwitterMethods
  include ::MuckEngineHelper
  
  has_one :authentication, :as => :authenticatable, :dependent => :destroy
  has_many :items
  belongs_to :project
  
  has_friendly_id :name, :use_slug => true
  
  scope :by_name, order("name ASC")
  scope :by_newest, order("characters.created_at DESC")
  scope :by_oldest, order("characters.created_at ASC")
  scope :by_latest, order("characters.updated_at DESC")
  scope :newer_than, lambda { |*args| where("characters.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("characters.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  validates_presence_of :name
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
  
  after_save :twitter_update

  def twitter_update
    return false unless self.authentication
    client.update_profile(:name => self.name, 
                          :location => 'Somewhere in TwHistory', 
                          :url => "http://www.#{MuckEngine.configuration.base_domain}/projects/#{self.project.to_param}/characters/#{self.to_param}", 
                          :description => truncate_on_word(self.bio, 160))
    # client.update_profile_image(self.photo.to_file(:medium)) # TODO this isn't working right now. Uncomment when you have time to debug the twitter gem
  end
  
end