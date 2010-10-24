require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItemsController do

  render_views
    
  before(:each) do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
    @broadcast = Factory(:broadcast, :project => @project)
    @scheduled_item = Factory(:scheduled_item, :broadcast => @broadcast)
  end

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'edit', :get, '/login' }
  it { should require_login 'update', :put, '/login' }
  
  def mock_scheduled_item(stubs={})
    (@mock_scheduled_item ||= mock_model(ScheduledItem).as_null_object).tap do |scheduled_item|
      scheduled_item.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all scheduled_items as @scheduled_items" do
      ScheduledItem.stub(:all) { [mock_scheduled_item] }
      get :index
      assigns(:scheduled_items).should eq([mock_scheduled_item])
    end
  end

  describe "GET show" do
    it "assigns the requested scheduled_item as @scheduled_item" do
      ScheduledItem.stub(:find).with("37") { mock_scheduled_item }
      get :show, :id => "37"
      assigns(:scheduled_item).should be(mock_scheduled_item)
    end
  end

  describe "GET new" do
    it "assigns a new scheduled_item as @scheduled_item" do
      ScheduledItem.stub(:new) { mock_scheduled_item }
      get :new
      assigns(:scheduled_item).should be(mock_scheduled_item)
    end
  end

  describe "GET edit" do
    it "assigns the requested scheduled_item as @scheduled_item" do
      ScheduledItem.stub(:find).with("37") { mock_scheduled_item }
      get :edit, :id => "37"
      assigns(:scheduled_item).should be(mock_scheduled_item)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created scheduled_item as @scheduled_item" do
        ScheduledItem.stub(:new).with({'these' => 'params'}) { mock_scheduled_item(:save => true) }
        post :create, :scheduled_item => {'these' => 'params'}
        assigns(:scheduled_item).should be(mock_scheduled_item)
      end

      it "redirects to the created scheduled_item" do
        ScheduledItem.stub(:new) { mock_scheduled_item(:save => true) }
        post :create, :scheduled_item => {}
        response.should redirect_to(scheduled_item_url(mock_scheduled_item))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved scheduled_item as @scheduled_item" do
        ScheduledItem.stub(:new).with({'these' => 'params'}) { mock_scheduled_item(:save => false) }
        post :create, :scheduled_item => {'these' => 'params'}
        assigns(:scheduled_item).should be(mock_scheduled_item)
      end

      it "re-renders the 'new' template" do
        ScheduledItem.stub(:new) { mock_scheduled_item(:save => false) }
        post :create, :scheduled_item => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested scheduled_item" do
        ScheduledItem.should_receive(:find).with("37") { mock_scheduled_item }
        mock_scheduled_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :scheduled_item => {'these' => 'params'}
      end

      it "assigns the requested scheduled_item as @scheduled_item" do
        ScheduledItem.stub(:find) { mock_scheduled_item(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:scheduled_item).should be(mock_scheduled_item)
      end

      it "redirects to the scheduled_item" do
        ScheduledItem.stub(:find) { mock_scheduled_item(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(scheduled_item_url(mock_scheduled_item))
      end
    end

    describe "with invalid params" do
      it "assigns the scheduled_item as @scheduled_item" do
        ScheduledItem.stub(:find) { mock_scheduled_item(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:scheduled_item).should be(mock_scheduled_item)
      end

      it "re-renders the 'edit' template" do
        ScheduledItem.stub(:find) { mock_scheduled_item(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested scheduled_item" do
      ScheduledItem.should_receive(:find).with("37") { mock_scheduled_item }
      mock_scheduled_item.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the scheduled_items list" do
      ScheduledItem.stub(:find) { mock_scheduled_item }
      delete :destroy, :id => "1"
      response.should redirect_to(scheduled_items_url)
    end
  end

end
