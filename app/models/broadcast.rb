class Broadcast < ActiveRecord::Base
  include ::TwitterMethods
  include ::MuckEngineHelper
  
  belongs_to :project
  has_one :authentication, :as => :authenticatable, :dependent => :destroy
  has_many :scheduled_items, :dependent => :destroy
  
  scope :by_start, order("broadcasts.start_at DESC")
  scope :past, where("broadcasts.end_at <= ?", DateTime.now)
  scope :in_progress, where("broadcasts.start_at <= ? AND broadcasts.end_at >= ?", DateTime.now, DateTime.now)
  scope :future, where("broadcasts.start_at >= ?", DateTime.now)
  scope :current_and_future, where("broadcasts.start_at >= ? OR broadcasts.end_at >= ?", DateTime.now, DateTime.now)
  
  
  scope :by_newest, order("broadcasts.created_at DESC")
  scope :by_oldest, order("broadcasts.created_at ASC")
  scope :by_latest, order("broadcasts.updated_at DESC")
  scope :newer_than, lambda { |*args| where("broadcasts.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("broadcasts.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  def parse_start_at(params)
    self.start_at = Time.zone.parse("#{params[:start_date]} #{params[:start_time]}")
  end
  
  def twitter_update
    return false unless self.authentication
    client.update_profile(:name => self.name, 
                          :location => self.project.location, 
                          :url => self.project_url, 
                          :description => twitter_description)
    # client.update_profile_image(self.project.photo.to_file(:medium)) # TODO this isn't working right now. Uncomment when you have time to debug the twitter gem
  end
  
  def twitter_description
    truncate_on_word(self.project.description, 160)
  end
  
  def name
    self.project.title
  end

  # Used to build json for calendar
  delegate :title, :to => :project
  
  def start
    self.start_at
  end
  
  def end
    self.end_at || self.start_at
  end
	
	def project_url
    "http://#{MuckEngine.configuration.application_url}/projects/#{self.project.to_param}"
  end
  
  # Builds scheduled tweets based on scheduling parameters provided by the user
  def build_schedule
    items = self.project.items.chronological
    first_event_date_time = items.first.event_date_time
    broadcast_date_time = nil
    items.each do |item|
      broadcast_date_time = self.start_at + (item.event_date_time - first_event_date_time)
      BroadcastTweetJob.enqueue(self.id, item.id, broadcast_date_time)      
    end
    self.end_at = broadcast_date_time # Record the broadcast end date/time
    self.save
  end
  
  def retweet(tweet_id)
    self.client.retweet(tweet_id)
  end
  
end
