require File.expand_path("../../spec_helper", __FILE__)

describe Item do
  
  it { should belong_to :project }
  it { should belong_to :character }
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  it { should_not allow_mass_assignment_of :lat }
  it { should_not allow_mass_assignment_of :lng }
  it { should_not allow_mass_assignment_of :created_at }
  it { should_not allow_mass_assignment_of :updated_at }
  
  it { should validate_presence_of :content }
  it { should validate_presence_of :event_date_time }
  
  describe "scopes" do
    describe "by_event_date_time" do
      before do
        Item.delete_all
        @first_item = Factory(:item, :event_date_time => 1.month.ago)
        @second_item = Factory(:item, :event_date_time => 1.day.ago)
        @third_item = Factory(:item, :event_date_time => 1.day.from_now)
      end
      it "should order broadcasts by start date" do
        Item.by_event_date_time[0].should == @third_item
        Item.by_event_date_time[1].should == @second_item
        Item.by_event_date_time[2].should == @first_item
      end
    end
    describe "chronological" do
      before do
        Item.delete_all
        @first_item = Factory(:item, :event_date_time => 1.month.ago)
        @second_item = Factory(:item, :event_date_time => 1.day.ago)
        @third_item = Factory(:item, :event_date_time => 1.day.from_now)
      end
      it "should order broadcasts by start date" do
        Item.chronological[2].should == @third_item
        Item.chronological[1].should == @second_item
        Item.chronological[0].should == @first_item
      end
    end
    describe "untweeted" do
      before do
        Item.delete_all
        @tweeted = Factory(:item, :tweet_id => '237373')
        @untweeted = Factory(:item, :tweet_id => nil)
      end
      it "should order broadcasts by start date" do
        Item.untweeted.should_not include(@tweeted)
        Item.untweeted.should include(@untweeted)
      end
    end
    
  end
  
  describe "parse_event_date_time" do
    before do
      @item = Factory(:item)
    end
    it "should build event_date_time from params" do
      @item.parse_event_date_time({:event_date => '10/10/2010', :event_time => '10:10'})
      @item.event_date_time.should == DateTime.new('10/10/2010 10:10')
    end
  end
  
  describe "export_to_twitter" do
    it "calls client update and updates tweet_id" do
      authentication = Factory(:authentication)
      character = Factory(:character, :authentication => authentication)
      item = Factory(:item, :character => character)
      client = mock
      tweet = mock(:id => 1)
      client.should_receive(:update).with(item.content).and_return(tweet)
      character.should_receive(:client).and_return(client)
      item.export_to_twitter
    end
  end
  
end