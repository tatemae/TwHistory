require File.expand_path("../../../spec_helper", __FILE__)

describe "broadcasts/edit.html.erb" do
  before(:each) do
    @broadcast = assign(:broadcast, stub_model(Broadcast,
      :new_record? => false
    ))
  end

  it "renders the edit broadcast form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => broadcast_path(@broadcast), :method => "post" do
    end
  end
end
