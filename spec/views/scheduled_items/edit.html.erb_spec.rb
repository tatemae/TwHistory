require File.expand_path("../../../spec_helper", __FILE__)

describe "scheduled_items/edit.html.erb" do
  before(:each) do
    @scheduled_item = assign(:scheduled_item, stub_model(ScheduledItem,
      :new_record? => false
    ))
  end

  it "renders the edit scheduled_item form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => scheduled_item_path(@scheduled_item), :method => "post" do
    end
  end
end
