require File.expand_path("../../../spec_helper", __FILE__)

describe "scheduled_items/new.html.erb" do
  before(:each) do
    assign(:scheduled_item, stub_model(ScheduledItem).as_new_record)
  end

  it "renders new scheduled_item form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => scheduled_items_path, :method => "post" do
    end
  end
end
