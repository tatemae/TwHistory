require File.dirname(__FILE__) + '/../spec_helper'

class TestTwitterMethods
  include ::TwitterMethods
end

describe TwitterMethods do
  before(:each) do
    @twitter_methods = TestTwitterMethods.new
  end
  describe "client" do
    it "returns a client capable of talking to twitter" do
      authentication = mock()
      authentication.should_receive(:token).and_return('token')
      authentication.should_receive(:secret).and_return('secret')
      @twitter_methods.stub!(:authentication).return(authentication)
      client = @twitter_methods.client
      client.type.should == Twitter::Base
    end
  end
  describe "oauth" do
    it "returns a Twitter::OAuth object" do
      oauth = @twitter_methods.oauth
      oauth.type.should == Twitter::OAuth
    end
  end
end