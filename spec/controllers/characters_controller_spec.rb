require File.dirname(__FILE__) + '/../spec_helper'

describe CharactersController do

  render_views

  it { should require_login 'new', :get, '/login' }
  it { should require_login 'create', :post, '/login' }
  it { should require_login 'edit', :get, '/login' }
  it { should require_login 'update', :put, '/login' }
  
  describe "GET index" do
    before(:each) do
      @character = Factory(:character)
      get :index
    end
    it { should respond_with :success }
    it { should render_template :index }
  end
  
  describe "GET show" do
    before(:each) do
      @character = Factory(:character)
      get :show, :id => @character
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "logged in" do
    before do
      @user = Factory(:user)
      @project = Factory(:project, :user => @user)
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
        post :create, :character => Factory.attributes_for(:character, :project => @project)
      end
      it { should redirect_to(character_path(assigns(:character))) }
    end

    describe "GET edit" do
      before(:each) do
        @character = Factory(:character, :project => @project)
        get :edit, :id => @character
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
  
    describe "PUT to update" do
      before(:each) do
        @character = Factory(:character, :project => @project)
        post :create, :id => @character.id, :character => Factory.attributes_for(:character)
      end
      it { should redirect_to(character_path(assigns(:character))) }
    end
  
  end
  
end