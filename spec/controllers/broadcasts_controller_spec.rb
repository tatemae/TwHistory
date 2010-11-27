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
    before do
      @broadcast_in_progress = Factory(:broadcast, :project => @project, :start_at => 1.day.ago, :end_at => 1.day.from_now)
      @future_broadcast = Factory(:broadcast, :project => @project, :start_at => 1.day.from_now, :end_at => 1.week.from_now)
      @past_broadcast = Factory(:broadcast, :project => @project, :start_at => 1.week.ago, :end_at => 1.day.ago)
    end
    describe "with project" do
      before(:each) do
        get :index, :project_id => @project
      end
      it "assigns all broadcasts in progress" do
        assigns(:broadcasts_in_progress).should include(@broadcast_in_progress)
        assigns(:broadcasts_in_progress).should_not include(@past_broadcast)
        assigns(:broadcasts_in_progress).should_not include(@future_broadcast)
      end
      it "assigns future broadcasts" do
        assigns(:future_broadcasts).should include(@future_broadcast)
        assigns(:future_broadcasts).should_not include(@past_broadcast)
        assigns(:future_broadcasts).should_not include(@broadcast_in_progress)
      end
      it "assigns past broadcasts" do
        assigns(:past_broadcasts).should include(@past_broadcast)
        assigns(:past_broadcasts).should_not include(@future_broadcast)
        assigns(:past_broadcasts).should_not include(@broadcast_in_progress)
      end
      it { should respond_with :success }
      it { should render_template :index }
    end
    describe "without project" do
      before(:each) do
        get :index
      end
      it "assigns broadcasts in progress" do
        assigns(:broadcasts_in_progress).should include(@broadcast_in_progress)
        assigns(:broadcasts_in_progress).should_not include(@future_broadcast)
        assigns(:broadcasts_in_progress).should_not include(@past_broadcast)
      end
      it "assigns all broadcasts" do
        assigns(:broadcasts).should include(@broadcast)
        assigns(:broadcasts).should include(@broadcast_in_progress)
        assigns(:broadcasts).should include(@future_broadcast)
        assigns(:broadcasts).should include(@past_broadcast)
      end
      it { should respond_with :success }
      it { should render_template :index }
    end
  end
  
  describe "GET show" do
    before(:each) do
      get :show, :id => @broadcast, :project_id => @project
    end
    it "assigns the requested broadcast as @broadcast" do
      assigns(:broadcast).should == @broadcast
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "logged in" do
    before do
      @user.activate!
      activate_authlogic
      login_as @user
    end
    
    describe "GET new" do
      before(:each) do
        get :new, :project_id => @project
      end
      it { should respond_with :success }
      it { should render_template :new }
      it "should render a message indicating the user needs to add items" do
        response.body.should include('Unable to Add Broadcast')
      end
    end

    describe "GET new with items" do
      before(:each) do
        @item = Factory(:item, :project => @project)
        get :new, :project_id => @project
      end
      it { should respond_with :success }
      it { should render_template :new }
      it "should render form to add broadcast" do
        response.body.should include('The first event for this Re-enactment is:')
      end
    end
    
    describe "GET edit" do
      before(:each) do
        get :edit, :id => @broadcast, :project_id => @project
      end
      it "assigns the requested broadcast as @broadcast" do
        assigns(:broadcast).should == @broadcast  
      end
      it { should redirect_to(broadcast_path(@broadcast)) }
    end

    describe "POST create" do
      before(:each) do
        @broadcast.stub!(:parse_start_at)
        @broadcast.stub!(:save).and_return(true)
        @broadcast.stub!(:build_schedule).and_return(true)
        builder = mock('BroadcastBuilder')
        builder.stub!(:build).and_return(@broadcast)
        @project.stub!(:broadcasts).and_return(builder)
        Project.stub!(:find) { @project }
      end
      describe "with valid params" do
        it "assigns a newly created broadcast as @broadcast" do
          post :create, :broadcast => Factory.attributes_for(:broadcast), :start_date => '10/10/10', :start_time => '10:10:10 AM',  :project_id => @project
          assigns(:broadcast).should be(@broadcast)
        end
        it "redirects to the created broadcast" do
          post :create, :broadcast => Factory.attributes_for(:broadcast), :start_date => '10/10/10', :start_time => '10:10:10 AM', :project_id => @project
          response.should redirect_to(assigns(:broadcast))
        end
        it "parses the date and time" do
          @broadcast.should_receive(:parse_start_at)
          post :create, :broadcast => Factory.attributes_for(:broadcast), :start_date => '10/10/10', :start_time => '10:10:10 AM', :project_id => @project
        end
        it "builds out a schedule" do
          @broadcast.should_receive(:build_schedule).and_return(true)
          post :create, :broadcast => Factory.attributes_for(:broadcast), :start_date => '10/10/10', :start_time => '10:10:10 AM', :project_id => @project
        end
      end
      describe "with invalid params" do
        it "re-renders the 'new' template" do
          @broadcast.stub!(:save).and_return(false)
          post :create, :broadcast => {}, :project_id => @project
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested broadcast" do
          Broadcast.should_receive(:find).with("#{@broadcast.to_param}") { @broadcast }
          @broadcast.stub!(:parse_start_at)
          @broadcast.should_receive(:save).and_return(true)
          put :update, :id => @broadcast.to_param, :project_id => @project
        end
        it "should parse the start date" do
          Broadcast.stub!(:find) { @broadcast }
          @broadcast.should_receive(:parse_start_at)
          put :update, :id => @broadcast.to_param, :project_id => @project
        end
        it "assigns the requested broadcast as @broadcast" do
          Broadcast.stub!(:find) { @broadcast }
          @broadcast.stub!(:parse_start_at)
          @broadcast.stub!(:save).and_return(true)
          put :update, :id => @broadcast, :project_id => @project
          assigns(:broadcast).id.should == @broadcast.id
        end
        it "redirects to the broadcast" do
          Broadcast.stub!(:find) { @broadcast }
          @broadcast.stub!(:parse_start_at)
          @broadcast.stub!(:save).and_return(true)
          put :update, :id => @broadcast, :project_id => @project
          response.should redirect_to(broadcast_url(@broadcast))
        end
      end

      describe "with invalid params" do
        before(:each) do
          Broadcast.stub!(:find) { @broadcast }
          @broadcast.stub!(:parse_start_at)
          @broadcast.stub!(:save).and_return(false)          
        end
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
        Broadcast.should_receive(:find).with("#{@broadcast.to_param}") { @broadcast }
        @broadcast.should_receive(:destroy)
        delete :destroy, :id => @broadcast.to_param, :project_id => @project
      end

      it "redirects to the broadcasts list" do
        Broadcast.stub(:find) { @broadcast }
        delete :destroy, :id => "1", :project_id => @project
        response.should redirect_to(project_broadcasts_path(@project))
      end
    end

  end
  
end