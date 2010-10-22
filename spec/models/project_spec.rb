require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  it { should have_many :items }
  it { should have_many :characters }
  it { should have_many :authentications }
  it { should belong_to :user }
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  describe "can_edit?" do
    before do
      @user = Factory(:user)
      @project_user = Factory(:user)
      @project = Factory(:project, :user => @project_user)
    end
    it "should return false for nil user" do
      @project.can_edit?(nil).should be_false
    end
    it "should return false for non project user" do
      @project.can_edit?(@user).should be_false
    end
    it "should return true for project user" do
      @project.can_edit?(@project_user).should be_true
    end
  end
end
