require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItem do
  it {should belong_to :broadcast }
  it {should belong_to :item }
  
  describe "named scopes" do
    
    describe "by_send" do
      before do
        ScheduledItem.delete_all
        @old_item = Factory(:scheduled_item, :run_at => 1.month.ago)
        @new_item = Factory(:scheduled_item, :run_at => 1.day.ago)
        @future_item = Factory(:scheduled_item, :run_at => 1.day.from_now)
      end
      it "should order by send date" do        
        ScheduledItem.by_send[0].should == @old_item
        ScheduledItem.by_send[1].should == @new_item
        ScheduledItem.by_send[2].should == @future_item
      end
    end
    
    describe "ready_to_send" do
      before do
        ScheduledItem.delete_all
        @ready_item = Factory(:scheduled_item, :run_at => 1.day.ago)
        @ready_item_too = Factory(:scheduled_item, :run_at => 1.minute.ago)
        @not_ready_item = Factory(:scheduled_item, :run_at => 1.day.from_now)
      end
      it "should only find items that are ready to send" do
        ScheduledItem.ready_to_send.should include(@ready_item)
        ScheduledItem.ready_to_send.should include(@ready_item_too)
        ScheduledItem.ready_to_send.should_not include(@future_item)
      end
    end
    
  end
  
  describe "broadcast_scheduled_items" do
    before(:each) do
      ScheduledItem.delete_all
      @broadcast = Factory(:broadcast)
      @tweet = mock
      @client = mock
      @client.stub!(:retweet).and_return(@tweet)
      @ready_item = Factory(:scheduled_item, :broadcast => @broadcast, :run_at => 1.day.ago)
      @ready_item_too = Factory(:scheduled_item, :broadcast => @broadcast, :run_at => 1.minute.ago)
      @not_ready_item = Factory(:scheduled_item, :broadcast => @broadcast, :run_at => 1.day.from_now)
    end
    it "should broadcast all items that are ready to send" do
      @broadcast.should_receive(:client).and_return(@client)
      ScheduledItem.broadcast_scheduled_items
      (ScheduledItem.find(@ready_item.id) rescue nil).should be_nil
      (ScheduledItem.find(@ready_item_too.id) rescue nil).should be_nil
      (ScheduledItem.find(@not_ready_item.id)).should_not be_nil
    end
  end
  
end