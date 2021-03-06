class ItemsController < ApplicationController

  include ::CsvMethods
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project, :except => [:index, :update, :destroy]
  before_filter :setup_project_not_protected, :only => [:index]
  
  def index
    setup_will_paginate
    respond_to do |format|
      format.html do
        @items = @project.items.chronological.includes(:character).paginate(:page => @page, :per_page => @per_page)
      end
      format.xml do
        @items = @project.items.chronological.includes(:character)
        render :xml => @items
      end
      format.csv do
        @items = @project.items.chronological.includes(:character)
        stream_csv(@project.title) do |csv|
          csv << csv_header
          @items.each do |i|
            csv << csv_item(i)
          end
        end
      end
    end
  end

  def new
    @sidebar_off = true
    @item = @project.items.new
    @item.character_id = params[:character] if params[:character]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end
  
  def create
    if params[:item] && params[:item][:csv]
      @items, @results = @project.import_items(params[:item][:csv])
      if @results.empty?
        respond_to do |format|
          format.html { redirect_to(@project, :notice => translate('items.csv_import_success')) }
          format.xml  { render :xml => @items, :status => :created }
        end
      else
        @sidebar_off = true
        @item = @project.items.new
        respond_to do |format|
          format.html { render :action => "new", :notice => translate('items.csv_import_failure') }
          format.xml  { render :xml => @results, :status => :unprocessable_entity }
        end
      end
    else
      @item = @project.items.build(params[:item])
      @item.parse_event_date_time(params)
      respond_to do |format|
        if @item.save
          format.html { redirect_to(@project, :notice => translate('items.item_create_success')) }
          format.xml  { render :xml => @item, :status => :created, :location => @item }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    @item.parse_event_date_time(params)
    @project = @item.project
    respond_to do |format|
      if @project.can_edit?(current_user) && @item.update_attributes(params[:item])
        format.html { redirect_to(project_items_path(@project), :notice => 'Item was successfully updated.') }
        format.js { render :js => "jQuery('##{@item.dom_id}_message').html('Successfully updated.');" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { render :js => "jQuery('##{@item.dom_id}_message').html('Could not be updated.');" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @project = @item.project
    if @project.can_edit?(current_user)
      @item.destroy
      message = "Item Deleted"
      success = true
    else
      message = "You don't have rights to delete the specified item"
      success = false
    end
    respond_to do |format|
      format.html { redirect_to(project_items_url(@project), :notice => message) }
      format.xml { head :ok }
      format.js do
        if success
          render :js => "jQuery('##{@item.dom_id}').fadeOut();"
        else
          render :js => "jQuery('##{@item.dom_id}_message').html('#{message}');"
        end
      end
    end
  end
  
  private
  
    def csv_header
      ["Event Date", "Event Time", "Character Name", "Content", "Location", "Source", "Photo"]
    end

    def csv_item(i)
      [i.event_date_time.try(:to_s, :short_date), i.event_date_time.try(:to_s, :just_time), i.character.name, i.content, i.location, i.source, "http://#{MuckEngine.configuration.application_url}#{i.character.photo.url}"]
    end
end
