require File.expand_path("../../spec_helper", __FILE__)

describe Project do
  it { should have_many :items }
  it { should have_many :characters }
  it { should have_many :authentications }
  it { should have_many :broadcasts }
  it { should belong_to :user }
  it { should have_many :authorized_users }
  
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
      @project.characters.any?{|c| c.name == 'C Lightoller'}.should be_true
      @project.characters.any?{|c| c.name == 'J Phillips'}.should be_true
      @project.characters.any?{|c| c.name == 'Capt Smith'}.should be_true
      # Items
      @project.items.any?{ |i| i.content == 'Just sent lifeboat 12 away with 40 women and children' && i.event_date_time == DateTime.new("Jun 11, 1912 1:20 AM") }.should be_true
      @project.items.any?{ |i| i.content == 'Word is we are sinking. Staying at my post. Trying to raise another ship on our wireless' && i.event_date_time == DateTime.new("Jun 11, 1912 1:25 AM") }.should be_true
      @project.items.any?{ |i| i.content == "Titanic just lurched to port, with the deck tilting. The band is playing for us. Boats No. 9 and No. 10 are lowering." && i.event_date_time == DateTime.new("Jun 11, 1912 1:15 AM") }.should be_true
    end
  end
  
end
