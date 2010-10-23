require File.expand_path("../../../spec_helper", __FILE__)

describe "scheduled_items/show.html.erb" do
  before(:each) do
    @scheduled_item = assign(:scheduled_item, stub_model(ScheduledItem))
  end

  it "renders attributes in <p>" do
    render
  end
end
