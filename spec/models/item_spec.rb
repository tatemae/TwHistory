require File.expand_path("../../spec_helper", __FILE__)

describe Item do
  
  it { should belong_to :project }
  it { should belong_to :character }
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  it { should_not allow_mass_assignment_of :lat }
  it { should_not allow_mass_assignment_of :lng }
  it { should_not allow_mass_assignment_of :created_at }
  it { should_not allow_mass_assignment_of :updated_at }
  
  it { should validate_presence_of :content }
  it { should validate_presence_of :event_date_time }
  
  describe "parse_event_date_time" do
    setup do
      @item = Factory(:item)
    end
    it "should build event_date_time from params" do
      @item.parse_event_date_time({:event_date => '10/10/2010', :event_time => '10:10'})
      @item.event_date_time.should == DateTime.new('10/10/2010 10:10')
    end
  end
  
end