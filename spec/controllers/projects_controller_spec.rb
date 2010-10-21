require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController do

  render_views

  it { should require_login 'new', :get, '/signup' }
  it { should require_login 'create', :post, '/signup' }
  it { should require_login 'edit', :get, '/signup' }
  it { should require_login 'update', :put, '/signup' }
  
  describe "GET show" do
    before(:each) do
      @project = Project(:factory)
      get :show, :id => @project
    end
    it { should respond_with :success }
    it { should render_template :show }
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
      post :create, :project => Factory.attributes_for(:project)
    end
    it { should redirect_to(project_path(assigns(:project))) }
  end

  describe "GET edit" do
    before(:each) do
      @project = Project(:factory)
      get :edit, :id => @project
    end
    it { should respond_with :success }
    it { should render_template :edit }
  end
  
  describe "PUT to update" do
    before(:each) do
      @project = Project(:factory)
      post :create, :id => @project.id, :project => Factory.attributes_for(:project)
    end
    it { should redirect_to(project_path(assigns(:project))) }
  end
  
end