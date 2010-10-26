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
    
  end
  
end