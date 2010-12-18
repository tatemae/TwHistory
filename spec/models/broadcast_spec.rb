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
    
    describe "by_old" do
      before do
        Broadcast.delete_all
        @old_item = Factory(:broadcast, :start_at => 1.month.ago)
        @new_item = Factory(:broadcast, :start_at => 1.day.ago)
        @future_item = Factory(:broadcast, :start_at => 1.day.from_now)
      end
      it "should order broadcasts by start date" do
        Broadcast.by_start[0].should == @old_item
        Broadcast.by_start[1].should == @new_item
        Broadcast.by_start[2].should == @future_item
      end
    end
    
    describe "past" do
      before do
        Broadcast.delete_all
        @past_item = Factory(:broadcast, :end_at => 1.day.ago)
        @future_item = Factory(:broadcast, :end_at => 1.day.from_now)
      end
      it "should only find broadcasts that have passed" do
        Broadcast.past.should_not include(@future_item)
        Broadcast.past.should include(@past_item)
      end
    end
    
    describe "in_progress" do
      before do
        Broadcast.delete_all
        @past_item = Factory(:broadcast, :start_at => 1.week.ago, :end_at => 1.day.ago)
        @inprogress = Factory(:broadcast, :start_at => 1.day.ago, :end_at => 1.day.from_now)
        @future_item = Factory(:broadcast, :start_at => 1.day.from_now, :end_at => 1.week.from_now)
      end
      it "should only find broadcasts that are in progress" do
        Broadcast.in_progress.should_not include(@past_item)
        Broadcast.in_progress.should_not include(@future_item)
        Broadcast.in_progress.should include(@inprogress)
      end
    end
    
    describe "future" do
      before do
        Broadcast.delete_all
        @past_item = Factory(:broadcast, :start_at => 1.day.ago)
        @future_item = Factory(:broadcast, :start_at => 1.day.from_now)
      end
      it "should find future broadcasts" do
        Broadcast.future.should include(@future_item)
      end
      it "should not find past broadcasts" do
        Broadcast.future.should_not include(@past_item)
      end
    end
  end
  
  describe "title" do
    before do
      @title = 'a great title'
      @project = Factory(:project, :title => @title)
      @broadcast = Factory(:broadcast, :project => @project)
    end
    it "should give the project's title" do
      @broadcast.title.should == @title
    end
  end
  
  describe "name" do
    before do
      @title = 'a great title'
      @project = Factory(:project, :title => @title)
      @broadcast = Factory(:broadcast, :project => @project)
    end
    it "should give the project's title for name" do
      @broadcast.name.should == @title
    end
  end
  
  describe "parse_start_at" do
    before do
      @broadcast = Factory(:broadcast)
    end
    it "should build parse_start_at from params" do
      @broadcast.parse_start_at({:start_date => '10/10/2010', :start_time => '10:10:00 AM'})
      @broadcast.start_at.should == DateTime.parse('10/10/2010 10:10:00 AM')
    end
  end
  
  describe "project_url" do
    it "should build " do
      broadcast = Factory(:broadcast)
      broadcast.project_url.should == "http://#{MuckEngine.configuration.application_url}/projects/#{broadcast.project.to_param}"
    end
  end
  
  describe "build_schedule" do
    before do
      @broadcast = Factory(:broadcast)
    end
    it "should create scheduled items (delayed jobs)" do
    end
  end
  
  describe "twitter_update" do
    before do
      @project = Factory(:project, :location => 'Some where in TwHistory')
      @broadcast = Factory(:broadcast, :project => @project)
      @broadcast.authentication = nil
    end
    describe "authentication is nil" do
      it "should return false if authentication is nil" do
        @broadcast.twitter_update.should be_false
      end
    end
    describe "authentication is valid" do
      before do
        @broadcast.authentication = Factory(:authentication, :token => 'token', :secret => 'secret')
        @client = mock_model('TwitterClient')
        @broadcast.stub!(:client).and_return(@client)
      end
      it "should update the profile image and profile details" do
        #@client.should_receive(:update_profile_image).with(@broadcast.photo.url(:medium) )
        @client.should_receive(:update_profile).with(:name => @broadcast.name, 
                                                     :location => @broadcast.project.location, 
                                                     :url => @broadcast.project_url, 
                                                     :description => @broadcast.twitter_description)
        @broadcast.twitter_update
      end
    end 
  end
  
end
