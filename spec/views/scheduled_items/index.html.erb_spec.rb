require File.expand_path("../../../spec_helper", __FILE__)

describe "scheduled_items/index.html.erb" do
  before(:each) do
    assign(:scheduled_items, [
      stub_model(ScheduledItem),
      stub_model(ScheduledItem)
    ])
  end

  it "renders a list of scheduled_items" do
    render
  end
end
