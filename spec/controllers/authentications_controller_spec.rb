require File.expand_path("../../spec_helper", __FILE__)

describe AuthenticationsController do
  
  render_views
  
  before(:each) do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
    @broadcast = Factory(:broadcast, :project => @project)
    @authentication = Factory(:authentication, :authenticatable => @broadcast)
  end

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'destroy', :delete, '/login' }

  describe "logged in" do
    before do
      @user.activate!
      activate_authlogic
      login_as @user
    end
    
    describe "GET new" do
      before(:each) do
        get :new, :broadcast_id => @broadcast
      end
      it { should redirect_to '/auth/twitter' }
      it "should set a session variable with the parent information" do
        session[:parent].should_not be_empty
        session[:parent][:parent_type].should == @broadcast.class.to_s
        session[:parent][:parent_id].should == @broadcast.id
      end
    end
  
    describe "POST create" do
    
    end
  
    describe "DELETE destroy" do
      before(:each) do
        @authentication_id = @authentication.id
        delete :destroy, :id => @authentication
      end
      it { should redirect_to @broadcast }
      it "deletes the authentication" do
        found = Authentication.find(@authentication_id) rescue nil
        found.should be_nil
      end
    end
  
  end
end