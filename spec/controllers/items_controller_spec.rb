require File.expand_path("../../spec_helper", __FILE__)

describe ItemsController do

  before do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
  end
  
  render_views

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'edit', :get, '/login' }
  it { should require_login 'update', :put, '/login' }
  
  describe "GET index" do
    describe "html" do
      before(:each) do
        get :index, :project_id => @project
      end
      it { should respond_with :success }
      it { should render_template :index }
    end
    describe "xml" do
      before(:each) do
        get :index, :project_id => @project, :format => 'xml'
      end
      it { should respond_with :success }
    end
    describe "csv" do
      before(:each) do
        get :index, :project_id => @project, :format => 'csv'
      end
      it { should respond_with :success }
    end
  end

  describe "logged in" do
    before do
      @user.activate!
      activate_authlogic
      login_as @user
    end
    
    describe "GET new" do
      before(:each) do
        get :new, :project_id => @project.id
      end
      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "POST to create" do
      describe "standard create" do
        it "redirects to project item path after update" do
          @character = Factory(:character)
          post :create, :item => Factory.attributes_for(:item, :project => @project, :character => @character), :project_id => @project.id
          response.should redirect_to(project_path(assigns(:project)))
        end
        it "renders new if new item has errors" do
          post :create, :item => Factory.attributes_for(:item, :project => @project), :project_id => @project.id
          assigns(:item).errors[:character_id].should == ["can't be blank"]
          response.should render_template("new")
        end
        it "prevents unauthorized user from adding items to the project" do
          @project.stub!('can_edit?').and_return(false)
          Project.stub(:find) { @project }
          post :create, :item => Factory.attributes_for(:item, :project => @project), :project_id => @project.id
          response.should redirect_to(project_path(@project))
        end
      end
      describe "csv create" do
        before(:each) do            
          post :create, :item => { :csv => fixture_file_upload("#{::Rails.root}/spec/fixtures/items.csv", 'text/csv') }, :project_id => @project.id
        end
        it { should redirect_to(project_path(assigns(:project))) }        
      end
    end

    describe "GET edit" do
      before(:each) do
        @item = Factory(:item, :project => @project)
        get :edit, :id => @item, :project_id => @project
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
  
    describe "PUT to update" do
      before(:each) do
        @item = Factory(:item, :project => @project)
      end
      describe "html" do
        it "redirects to project items path after update" do
          Item.stub(:find) { @item }
          @item.stub!(:update_attributes).and_return(true)
          @item.stub!(:parse_event_date_time)
          @project.stub!('can_edit?').and_return(true)
          put :update, :id => @item.id, :item => Factory.attributes_for(:item)
          response.should redirect_to(project_items_path(@project))
        end
        it "finds the item" do
          Item.should_receive(:find).with(@item.to_param).and_return(@item)
          put :update, :id => @item.to_param, :item => Factory.attributes_for(:item)
          assigns(:item).should be(@item)
        end
        it "updates the item" do
          Item.stub(:find) { @item }
          attributes = {'anything' => 'goes'}
          @item.should_receive(:update_attributes).with(attributes)
          @project.stub!('can_edit?').and_return(true)
          @item.stub!(:parse_event_date_time)
          put :update, :id => @item.id, :item => attributes
        end
        it "only allows specific users to update the item" do
          Item.stub(:find) { @item }
          @item.stub!(:update_attributes).and_return(true)
          @item.stub!(:parse_event_date_time)
          @item.stub!(:project).and_return(@project)
          @project.should_receive('can_edit?').with(@user).and_return(true)
          put :update, :id => @item.id
        end
        it "parses the event date/time" do
          Item.stub(:find) { @item }
          @item.stub!(:update_attributes).and_return(true)
          @project.stub!('can_edit?').and_return(true)
          @item.should_receive(:parse_event_date_time)
          put :update, :id => @item.id
        end
      end
      describe "js" do
        it "responds with js" do
          Item.stub(:find) { @item }
          @item.stub!(:parse_event_date_time)
          @item.stub!(:update_attributes).and_return(true)
          @project.stub!('can_edit?').and_return(true)
          put :update, :id => @item.to_param, :format => 'js'
          response.code.should == '200'
        end
      end
      describe "with invalid params" do
        it "responds to html and re-renders the 'edit' template" do
          Item.stub(:find) { @item }
          @item.stub!(:parse_event_date_time)
          @item.stub!(:save).and_return(false)
          put :update, :id => @item.to_param
          response.should render_template("edit")
        end
        it "responds with js" do
          Item.stub(:find) { @item }
          @item.stub!(:parse_event_date_time)
          @item.stub!(:save).and_return(false)
          put :update, :id => @item.to_param, :format => 'js'
          response.code.should == '200'
        end
      end
    end
  
    describe "DELETE destroy" do
      before(:each) do
        @item = Factory(:item, :project => @project)
      end
      describe "html" do
        it "destroys the requested item" do
          Item.stub(:find) { @item }
          @item.should_receive(:project).and_return(@project)
          @project.should_receive('can_edit?').with(@user).and_return(true)          
          @item.should_receive(:destroy)
          delete :destroy, :id => @item
        end
        it "only allows specific users to delete the item" do
          Item.stub(:find) { @item }
          @project.should_receive('can_edit?').with(@user).and_return(true)
          @item.stub!(:parse_event_date_time)
          delete :destroy, :id => @item
        end
        it "redirects to the project items list" do
          delete :destroy, :id => @item
          response.should redirect_to(project_items_path(@item.project))
        end
      end
      describe "js request" do
        it "destroys the requested item" do
          delete :destroy, :id => @item, :format => 'js'
          response.code.should == '200'
        end
      end
    end
  end
  
end