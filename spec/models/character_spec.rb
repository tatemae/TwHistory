require File.expand_path("../../spec_helper", __FILE__)

describe Character do
  
  it { should belong_to :project }
  it { should have_many :items }
  it { should have_many :authentications }
  
  it { should scope_by_name }
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  it { should validate_presence_of :name }
  
  describe "twitter_update" do
    describe "authentication is nil" do
      before do
        @character = Factory(:character)
      end
      it "should return false if authentication is nil" do
        @character.twitter_update.should be_false
      end
    end
    describe "authentication is valid" do
      before do
        @character.authentication = Factory(:authentication, :token => 'token', :secret => 'secret')
        @client = mock_model(Twitter::Base)
        @character.stub!(:client).and_return(@client)
      end
      it "should update the profile image and profile details" do
        #@client.should_receive(:update_profile_image).with(@character.photo.url(:medium) )
        @client.should_receive(:update_profile).with(:name => @character.name, 
                                                     :location => 'Somewhere in TwHistory', 
                                                     :url => project_character_path(@character.project, @character), 
                                                     :description => @character.bio[0...160])
        @character.twitter_update
      end
    end 
  end
  
end