class BroadcastTweetJob
  attr_accessor :broadcast_id
  attr_accessor :item_id
  
  def initialize(broadcast_id, item_id)
    self.item_id = item_id
    self.broadcast_id = broadcast_id
  end
  
  def perform
    item = Item.find(self.item_id) rescue nil
    broadcast = Broadcast.find(self.broadcast_id) rescue nil
    if item && broadcast
      # TODO need to throttle and possibly not destroy if tweet is not successful. Maybe re-queue a failed request
      # Rate limiting: http://dev.twitter.com/pages/rate-limiting
      tweet = item.export_to_twitter
      retweet = broadcast.retweet(tweet.id)
    end
  end

  def self.enqueue(broadcast_id, item_id, broadcast_date_time)
    Delayed::Job.enqueue(:payload_object => BroadcastTweetJob.new(broadcast_id, item_id),
                         :run_at => broadcast_date_time.getutc,
                         :broadcast_id => broadcast_id, 
                         :item_id => item_id)
  end
end