require File.expand_path("../../spec_helper", __FILE__)

describe ScheduledItemsController do
  
  it { should require_login 'update', :put, '/login' }
  it { should require_login 'destroy', :delete, '/login' }

  describe "logged in" do 
    
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      activate_authlogic
      login_as @user
      @project = Factory(:project, :user => @user)
      @broadcast = Factory(:broadcast, :project => @project)
      @scheduled_item = Factory(:scheduled_item, :broadcast => @broadcast)
    end
        
    describe "PUT update" do
      
      describe "with valid params" do
        it "parses the date" do
          ScheduledItem.stub(:find) { @scheduled_item }
          @scheduled_item.should_receive(:parse_run_at)
          put :update, :id => @scheduled_item.to_param, 'run_date' => '10/10/2010', 'run_time' => '10:10:10'
        end
        
        it "assigns the requested scheduled_item as @scheduled_item" do
          ScheduledItem.should_receive(:find).with(@scheduled_item.id.to_s).and_return(@scheduled_item)
          @scheduled_item.stub(:parse_run_at)
          put :update, :id => @scheduled_item.to_param
          assigns(:scheduled_item).should be(@scheduled_item)
        end

        it "redirects to the scheduled_item" do
          ScheduledItem.stub(:find) { @scheduled_item }
          @scheduled_item.stub(:parse_run_at)
          @scheduled_item.should_receive(:save).and_return(true)
          put :update, :id => @scheduled_item.to_param
          response.should redirect_to(@broadcast)
        end
      end

      describe "with invalid params" do
        it "responds to html and re-renders the 'show' template" do
          ScheduledItem.stub(:find) { @scheduled_item }
          @scheduled_item.should_receive(:parse_run_at)
          @scheduled_item.should_receive(:save).and_return(false)
          put :update, :id => @scheduled_item.to_param
          response.should render_template("broadcasts/show")
        end
        it "responds with js" do
          ScheduledItem.stub(:find) { @scheduled_item }
          @scheduled_item.should_receive(:parse_run_at)
          @scheduled_item.should_receive(:save).and_return(false)
          put :update, :id => @scheduled_item.to_param
          response.code.should == '200'
        end
      end

    end

    describe "DELETE destroy" do
      describe "html request" do
        it "destroys the requested scheduled_item" do
          ScheduledItem.stub(:find) { @scheduled_item }
          @scheduled_item.should_receive(:broadcast).and_return(@broadcast)
          @broadcast.should_receive(:project).and_return(@project)
          @project.should_receive('can_edit?').with(@user).and_return(true)          
          @scheduled_item.should_receive(:destroy)
          delete :destroy, :id => @scheduled_item
        end
      
        it "redirects to the scheduled_items list" do
          delete :destroy, :id => @scheduled_item
          response.should redirect_to(@scheduled_item.broadcast)
        end
      end
      describe "js request" do
        it "destroys the requested scheduled_item" do
          delete :destroy, :id => @scheduled_item, :format => 'js'
          response.code.should == '200'
        end
      end
    end

  end
end