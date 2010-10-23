require File.dirname(__FILE__) + '/../spec_helper'

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
    before(:each) do
      get :index, :project_id => @project
    end
    it { should respond_with :success }
    it { should render_template :index }
  end
  
  describe "GET show" do
    before(:each) do
      @item = Factory(:item)
      get :show, :id => @item, :project_id => @project
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
    end

    describe "POST to create" do
      describe "standard create" do
        before(:each) do
          post :create, :item => Factory.attributes_for(:item, :project => @project), :project_id => @project
        end
        it { should redirect_to(item_path(assigns(:item))) }
      end
      describe "csv create" do
        before(:each) do            
          post :create, :item => { :csv => fixture_file_upload("#{::Rails.root}/spec/fixtures/items.csv", 'text/csv') }, :project_id => @project
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
        post :create, :id => @item.id, :item => Factory.attributes_for(:item), :project_id => @project
      end
      it { should redirect_to(item_path(assigns(:item))) }
    end
  
  end
  
end