require File.expand_path("../../spec_helper", __FILE__)

describe Character do
  
  it { should belong_to :project }
  it { should have_many :items }
  it { should have_many :authentications }
  
  it { should scope_by_name }
  
end