require "spec_helper"

describe BroadcastsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/broadcasts" }.should route_to(:controller => "broadcasts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/broadcasts/new" }.should route_to(:controller => "broadcasts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/broadcasts/1" }.should route_to(:controller => "broadcasts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/broadcasts/1/edit" }.should route_to(:controller => "broadcasts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/broadcasts" }.should route_to(:controller => "broadcasts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/broadcasts/1" }.should route_to(:controller => "broadcasts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/broadcasts/1" }.should route_to(:controller => "broadcasts", :action => "destroy", :id => "1")
    end

  end
end
