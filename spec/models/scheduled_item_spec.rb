require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItem do
  it {should belong_to :broadcast }
  it {should belong_to :item }
  
  it { should validate_presence_of :send_at }
  
  describe "named scopes" do
    describe "by_send" do
      before do
        ScheduledItem.delete_all
        @old_item = Factory(:scheduled_item, :start_at => 1.month.ago)
        @new_item = Factory(:scheduled_item, :start_at => 1.day.ago)
        @future_item = Factory(:scheduled_item, :start_at => 1.day.from_now)
      end
      ScheduledItem.by_send[0].should == @future_item
      ScheduledItem.by_send[1].should == @new_item
      ScheduledItem.by_send[2].should == @old_item
    end
    
  end
  
end
