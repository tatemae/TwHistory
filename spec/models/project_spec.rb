require File.expand_path("../../spec_helper", __FILE__)

describe Project do
  it { should have_many :items }
  it { should have_many :characters }
  it { should have_many :broadcasts }
  it { should belong_to :user }
  it { should have_many :authorized_users }
  it { should have_many :project_roles }
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  describe "can_edit?" do
    before do
      @user = Factory(:user)
      @project_owner = Factory(:user)
      @project = Factory(:project, :user => @project_owner)
      @project_user = Factory(:user)
      @project.authorized_users << @project_user
    end
    it "should return false for nil user" do
      @project.can_edit?(nil).should be_false
    end
    it "should return false for non project user" do
      @project.can_edit?(@user).should be_false
    end
    it "should return true for project owner" do
      @project.can_edit?(@project_owner).should be_true
    end
    it "should return true for project user" do
      @project.can_edit?(@project_user).should be_true
    end
  end
  
  describe "import_items" do
    before do
      @project = Factory(:project)
      @items_file = fixture_file_upload("#{::Rails.root}/spec/fixtures/items.csv", 'text/csv')
    end
    it "should parse a csv file into items" do
      @project.import_items(@items_file)
      @project.reload
      # Characters
      @project.characters.any?{|c| c.name == 'Levi Jackman'}.should be_true
      @project.characters.any?{|c| c.name == 'Heber Kimball'}.should be_true
      # Items
      @project.items.any?{ |i| i.content == 'I am leaving home with Simon Cantier as pianears to go with the Company of pianears to finde a location for the Saints Some whair in the west' && i.event_date_time == DateTime.new("03/29/1847 09:34:00 AM") }.should be_true
      @project.items.any?{ |i| i.content == 'Just arrived at the main camp on the west side of the Missouri river. Likely leave in the morning.' && i.event_date_time == DateTime.new("04/01/1847 07:30:00") }.should be_true
      @project.items.any?{ |i| i.content == 'Leaving Winter Quarters with 6 of my teams","Along the Pioneer Trail' && i.event_date_time == DateTime.new("04/05/1847 08:29:00") }.should be_true
    end
  end
  
  describe "authentication_name" do
    before(:each) do
      @project = Factory(:project)
    end
    it "should respond to 'authentication_name' with title" do
      @project.authentication_name.should == @project.title
    end
  end
  
end
