require File.expand_path("../../../spec_helper", __FILE__)

describe "broadcasts/show.html.erb" do
  before(:each) do
    @broadcast = assign(:broadcast, stub_model(Broadcast))
  end

  it "renders attributes in <p>" do
    render
  end
end
