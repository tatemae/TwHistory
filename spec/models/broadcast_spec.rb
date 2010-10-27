require File.expand_path("../../spec_helper", __FILE__)

describe Broadcast do
  it { should have_one :authentication }
  it { should belong_to :project }
  it { should have_many :scheduled_items }
  
  describe "scopes" do
    
    it { should scope_by_latest }
    it { should scope_by_newest }
    it { should scope_by_oldest }
    it { should scope_newer_than }
    it { should scope_older_than }
    
    describe "by_start" do
      before do
        Broadcast.delete_all
        @old_item = Factory(:broadcast, :start_at => 1.month.ago)
        @new_item = Factory(:broadcast, :start_at => 1.day.ago)
        @future_item = Factory(:broadcast, :start_at => 1.day.from_now)
      end
      it "should order broadcasts by start date" do
        Broadcast.by_start[0].should == @future_item
        Broadcast.by_start[1].should == @new_item
        Broadcast.by_start[2].should == @old_item
      end
    end
    
    scope :past, where("broadcasts.end_at <= ?", DateTime.now)
    scope :in_progress, where("broadcasts.start_at <= ? AND broadcasts.end_at >= ?", DateTime.now)
    scope :future, where("broadcasts.start_at >= ?", DateTime.now)
    
    
    describe "not_past" do
      before do
        Broadcast.delete_all
        @past_item = Factory(:broadcast, :start_at => 1.day.ago)
        @future_item = Factory(:broadcast, :start_at => 1.day.from_now)
      end
      it "should find future broadcasts" do
        Broadcast.not_past.should include(@future_item)
      end
      it "should not find past broadcasts" do
        Broadcast.not_past.should_not include(@past_item)
      end
    end
  end
  
  describe "parse_start_at" do
    before do
      @broadcast = Factory(:broadcast)
    end
    it "should build parse_start_at from params" do
      @broadcast.parse_start_at({:event_date => '10/10/2010', :event_time => '10:10'})
      @broadcast.start_at.should == DateTime.new('10/10/2010 10:10')
    end
  end
  
  describe "twitter_update" do
    describe "authentication is nil" do
      before do
        @broadcast = Factory(:broadcast)
      end
      it "should return false if authentication is nil" do
        @broadcast.twitter_update.should be_false
      end
    end
    describe "authentication is valid" do
      before do
        @broadcast.authentication = Factory(:authentication, :token => 'token', :secret => 'secret')
        @client = mock_model(Twitter::Base)
        @broadcast.stub!(:client).and_return(@client)
      end
      it "should update the profile image and profile details" do
        #@client.should_receive(:update_profile_image).with(@broadcast.photo.url(:medium) )
        @client.should_receive(:update_profile).with(:name => @broadcast.name, 
                                                     :location => 'Somewhere in TwHistory', 
                                                     :url => project_broadcast_path(@broadcast.project, @broadcast), 
                                                     :description => @broadcast.bio[0...160])
        @broadcast.twitter_update
      end
    end 
  end
  
end
