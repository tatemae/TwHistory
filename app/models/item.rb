class Item < ActiveRecord::Base
  include RemoteFileMethods
  
  belongs_to :project
  belongs_to :character
  
  scope :by_event_date_time, order("items.event_date_time DESC")
  scope :chronological, order("items.event_date_time ASC")
  scope :by_newest, order("items.created_at DESC")
  scope :by_oldest, order("items.created_at ASC")
  scope :by_latest, order("items.updated_at DESC")
  scope :newer_than, lambda { |*args| where("items.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("items.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  scope :untweeted, where("tweet_id IS NULL")
  
  attr_protected :created_at, :updated_at, :lat, :lng
  validates_presence_of :content
  validates_presence_of :event_date_time
    
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" }
  
  def parse_event_date_time(params)
    self.event_date_time = DateTime.parse("#{params[:event_date]} #{params[:event_time]}")
  end
  
  def twitter_update
    return false unless self.character.authentication
    export_to_twitter
  end
  
  def export_to_twitter
    tweet = self.character.client.update(self.content)
    self.update_attribute(:tweet_id, tweet.id)
  end
  
end