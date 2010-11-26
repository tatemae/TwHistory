require File.expand_path("../../spec_helper", __FILE__)

describe Character do
  
  it { should belong_to :project }
  it { should have_many :items }
  it { should have_one :authentication }
  
  it { should scope_by_name }
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  it { should validate_presence_of :name }
  
  describe "twitter_update" do
    before do
      @character = Factory(:character)
    end
    describe "authentication is nil" do
      it "should return false if authentication is nil" do
        @character.twitter_update.should be_false
      end
    end
    describe "authentication is valid" do
      before do
        @character.authentication = Factory(:authentication, :token => 'token', :secret => 'secret')
        @client = mock_model('TwitterClient')
        @character.stub!(:client).and_return(@client)
      end
      it "should update the profile image and profile details" do
        #@client.should_receive(:update_profile_image).with(@character.photo.url(:medium) )
        @client.should_receive(:update_profile).with(:name => @character.name, 
                                                     :location => 'Somewhere in TwHistory', 
                                                     :url => @character.character_url, 
                                                     :description => @character.twitter_description)
        @character.twitter_update
      end
    end 
  end
  
end