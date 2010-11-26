require File.dirname(__FILE__) + '/../spec_helper'

describe BroadcastTweetJob do
  describe "perform" do
    it "exports the character's tweet and then retweets it to the broadcast's twitter account" do
      authentication = Factory(:authentication)
      broadcast_authentication = Factory(:authentication)
      character = Factory(:character, :authentication => authentication)
      broadcast = Factory(:broadcast, :authentication => broadcast_authentication)
      item = Factory(:item, :character => character)
      Item.should_receive(:find).with(item.id).and_return(item)
      Broadcast.should_receive(:find).with(broadcast.id).and_return(broadcast)

      tweet = mock(:id => 1)
      item.should_receive(:export_to_twitter).and_return(tweet)
      broadcast.should_receive(:retweet)
      BroadcastTweetJob.new(broadcast.id, item.id).perform
    end
  end
end