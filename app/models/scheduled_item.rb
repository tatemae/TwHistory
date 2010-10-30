class ScheduledItem < ActiveRecord::Base
  belongs_to :broadcast
  belongs_to :item
  
  validates_presence_of :send_at
  
  scope :by_send, order("scheduled_items.send_at ASC")
  scope :ready_to_send, where("scheduled_items.send_at <= ?", DateTime.now)
  
  def self.broadcast_scheduled_items
    to_send = ScheduledItem.ready_to_send.by_send.includes([:broadcast, :item])
    to_send.each do |scheduled_item|
      tweet = scheduled_item.broadcast.client.retweet(item.tweet_id)
      # TODO need to throttle and possibly not destroy if tweet is not successful
      # Rate limiting: http://dev.twitter.com/pages/rate-limiting
      scheduled_item.destroy
    end
  end
  
end
