require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController do

  render_views

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'edit', :get, '/login' }
  it { should require_login 'update', :put, '/login' }
  
  describe "GET index" do
    before(:each) do
      @project = Factory(:project)
      get :index
    end
    it { should respond_with :success }
    it { should render_template :index }
  end
  
  describe "GET show" do
    before(:each) do
      @project = Factory(:project)
      get :show, :id => @project
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "logged in" do
    before do
      @user = Factory(:user)
      @user.activate!
      activate_authlogic
      login_as @user
    end
    
    describe "GET new" do
      before(:each) do
        get :new
      end
      it { should respond_with :success }
      it { should render_template :new }
    end

    describe "POST to create" do
      before(:each) do
        post :create, :project => Factory.attributes_for(:project, :user => @user)
      end
      it { should redirect_to(project_path(assigns(:project))) }
    end

    describe "GET edit" do
      before(:each) do
        @project = Factory(:project, :user => @user)
        get :edit, :id => @project
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
  
    describe "PUT to update" do
      before(:each) do
        @project = Factory(:project, :user => @user)
        post :create, :id => @project.id, :project => Factory.attributes_for(:project)
      end
      it { should redirect_to(project_path(assigns(:project))) }
    end
  
  end
  
end