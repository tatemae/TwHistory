require File.expand_path("../../spec_helper", __FILE__)

describe BroadcastsController do
  
  render_views
    
  before(:each) do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
    @broadcast = Factory(:broadcast, :project => @project)
  end

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'edit', :get, '/login' }
  it { should require_login 'update', :put, '/login' }

  describe "GET index" do
    before(:each) do
      get :index, :project_id => @project
    end
    it "assigns all broadcasts as @broadcasts" do
      assigns(:broadcasts).should eq([@broadcast])
    end
    it { should respond_with :success }
    it { should render_template :index }
  end

  describe "GET show" do
    before(:each) do
      get :show, :id => @broadcast, :project_id => @project
    end
    it "assigns the requested broadcast as @broadcast" do
      assigns(:broadcast).should be(@broadcast)
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "GET new" do
    before(:each) do
      get :new, :project_id => @project
    end
    it { should respond_with :success }
    it { should render_template :new }
  end

  describe "GET edit" do
    before(:each) do
      get :edit, :id => @broadcast, :project_id => @project
    end
    it "assigns the requested broadcast as @broadcast" do
      assigns(:broadcast).should be(@broadcast)
    end
    it { should respond_with :success }
    it { should render_template :edit }
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created broadcast as @broadcast" do
        Broadcast.stub(:new).with({'these' => 'params'}) { mock_broadcast(:save => true) }
        post :create, :broadcast => {'these' => 'params'}, :project_id => @project
        assigns(:broadcast).should be(mock_broadcast)
      end

      it "redirects to the created broadcast" do
        Broadcast.stub(:new) { mock_broadcast(:save => true) }
        post :create, :broadcast => {}, :project_id => @project
        response.should redirect_to(broadcast_url(mock_broadcast))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved broadcast as @broadcast" do
        Broadcast.stub(:new).with({'these' => 'params'}) { mock_broadcast(:save => false) }
        post :create, :broadcast => {'these' => 'params'}, :project_id => @project
        assigns(:broadcast).should be(mock_broadcast)
      end

      it "re-renders the 'new' template" do
        Broadcast.stub(:new) { mock_broadcast(:save => false) }
        post :create, :broadcast => {}, :project_id => @project
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested broadcast" do
        Broadcast.should_receive(:find).with("37") { @broadcast }
        mock_broadcast.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :broadcast => {'these' => 'params'}, :project_id => @project
      end

      it "assigns the requested broadcast as @broadcast" do
        put :update, :id => @broadcast, :project_id => @project
        assigns(:broadcast).should be(mock_broadcast)
      end

      it "redirects to the broadcast" do
        put :update, :id => @broadcast, :project_id => @project
        response.should redirect_to(broadcast_url(@broadcast))
      end
    end

    describe "with invalid params" do
      it "assigns the broadcast as @broadcast" do
        put :update, :id => @broadcast, :project_id => @project
        assigns(:broadcast).should be(@broadcast)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @broadcast, :project_id => @project
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested broadcast" do
      Broadcast.should_receive(:find).with("37") { @broadcast }
      mock_broadcast.should_receive(:destroy)
      delete :destroy, :id => "37", :project_id => @project
    end

    it "redirects to the broadcasts list" do
      Broadcast.stub(:find) { mock_broadcast }
      delete :destroy, :id => "1", :project_id => @project
      response.should redirect_to(broadcasts_url)
    end
  end

end
