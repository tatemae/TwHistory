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
        @ready_item_too = Factory(:scheduled_item, :run_at => 5.minutes.ago)
        @not_ready_item = Factory(:scheduled_item, :run_at => 1.day.from_now)
      end
      it "should only find items that are ready to send" do
        ScheduledItem.ready_to_send.should include(@ready_item)
        ScheduledItem.ready_to_send.should include(@ready_item_too)
        ScheduledItem.ready_to_send.should_not include(@future_item)
      end
    end
    
  end
  
end