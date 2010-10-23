require File.expand_path("../../spec_helper", __FILE__)

describe User do
  it { should have_many :projects }
  
end
