require File.expand_path("../../spec_helper", __FILE__)

describe Broadcast do
  it { should have_one :authentication }
  it { should belong_to :project }
  it { should have_many :scheduled_items }
end
