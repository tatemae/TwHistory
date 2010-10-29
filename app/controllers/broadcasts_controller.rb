class BroadcastsController < ApplicationController

  before_filter :login_required, :except => [:index]
  before_filter :setup_project, :only => [:new, :create]
  
  def index
    @broadcasts_in_progress = Broadcast.by_start.limit(5) # TODO need to determine in progress
    setup_will_paginate
    @broadcasts = Broadcast.by_start.limit(100).includes(:project)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @broadcasts }
    end
  end

  def show
    @broadcast = Broadcast.find(params[:id])
    @can_edit_project = @broadcast.project.can_edit?(current_user)
    setup_will_paginate
    @scheduled_items = @broadcast.scheduled_items.by_send.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @broadcast }
    end
  end

  def new
    @broadcast = @project.broadcasts.build
    check_permissions
    respond_to do |format|
      format.html
      format.xml  { render :xml => @broadcast }
    end
  end

  def edit
    @broadcast = Broadcast.find(params[:id])
    check_permissions
  end

  def create
    @broadcast = @project.broadcasts.build(params[:broadcast])
    @broadcast.parse_start_at(params)
    check_permissions
    success = @broadcast.save
    # TODO calculate scheduled items
    respond_to do |format|
      if success
        format.html { redirect_to(@broadcast, :notice => translate('broadcasts.create_success')) }
        format.xml  { render :xml => @broadcast, :status => :created, :location => @broadcast }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @broadcast.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @broadcast = Broadcast.find(params[:id])
    check_permissions
    respond_to do |format|
      if @broadcast.update_attributes(params[:broadcast])
        format.html { redirect_to(@broadcast, :notice => 'Broadcast was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @broadcast.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @broadcast = Broadcast.find(params[:id])
    @broadcast.destroy
    respond_to do |format|
      format.html { redirect_to(broadcasts_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def check_permissions
      redirect_to(@project, :notice => "You don't have rights to change broadcast information for #{@broadcast.project.title}") unless @broadcast.project.can_edit?(current_user)
    end
end
