require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItem do
  it {should belong_to :broadcast }
  it {should belong_to :item }
  
  it { should validate_presence_of :send_at }
  
end
