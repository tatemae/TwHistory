require File.expand_path("../../spec_helper", __FILE__)

describe User do
  it { should belong_to :project }
  it { should belong_to :user }
end