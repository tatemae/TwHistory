require File.dirname(__FILE__) + '/../spec_helper'

describe UpdateCharacterTweetsJob do
  describe "perform" do
    it "exports the character's tweets" do
      authentication = Factory(:authentication)
      character = Factory(:character, :authentication => authentication)
      item = Factory(:item, :character => character)
      item.stub!(:export_to_twitter)
      untweeted = [item]
      Character.should_receive(:find).with(character.id).and_return(character)
      item.should_receive(:export_to_twitter)
      UpdateCharacterTwitterJob.new(character.id).perform
    end
  end
end