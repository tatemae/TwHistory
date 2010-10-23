require "spec_helper"

describe ScheduledItemsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/scheduled_items" }.should route_to(:controller => "scheduled_items", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/scheduled_items/new" }.should route_to(:controller => "scheduled_items", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/scheduled_items/1" }.should route_to(:controller => "scheduled_items", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/scheduled_items/1/edit" }.should route_to(:controller => "scheduled_items", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/scheduled_items" }.should route_to(:controller => "scheduled_items", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/scheduled_items/1" }.should route_to(:controller => "scheduled_items", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/scheduled_items/1" }.should route_to(:controller => "scheduled_items", :action => "destroy", :id => "1")
    end

  end
end
