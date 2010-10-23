require File.expand_path("../../../spec_helper", __FILE__)

describe "broadcasts/index.html.erb" do
  before(:each) do
    assign(:broadcasts, [
      stub_model(Broadcast),
      stub_model(Broadcast)
    ])
  end

  it "renders a list of broadcasts" do
    render
  end
end
