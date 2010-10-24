require File.expand_path("../../spec_helper", __FILE__)

describe AuthenticationsController do
  
  render_view
  
  before(:each) do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
    @authentication = Factory(:authentication, :authenticatable => @project)
  end

  it { should require_login 'create', :post, '/login' }
  it { should require_login 'destroy', :delete, '/login' }

  describe "GET index" do
    before(:each) do
      get :index, :project_id => @project
    end
    it "assigns all authentications as @authentications" do
      assigns(:authentications).should eq([@authentication])
    end
    it { should respond_with :success }
    it { should render_template :index }
  end
  
end