require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItemsController do

  render_views
    
  before(:each) do
    @user = Factory(:user)
    @project = Factory(:project, :user => @user)
    @broadcast = Factory(:broadcast, :project => @project)
    @scheduled_item = Factory(:scheduled_item, :broadcast => @broadcast)
  end

  it { should require_login 'update', :put, '/login' }
  it { should require_login 'destroy', :delete, '/login' }

  def mock_scheduled_item(stubs={})
    (@mock_scheduled_item ||= mock_model(ScheduledItem).as_null_object).tap do |scheduled_item|
      scheduled_item.stub(stubs) unless stubs.empty?
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
      @scheduled_item.should_receive(:destroy)
      delete :destroy, :id => @scheduled_item
    end

    it "redirects to the scheduled_items list" do
      delete :destroy, :id => @scheduled_item
      response.should redirect_to(@scheduled_item.broadcast)
    end
  end

end
