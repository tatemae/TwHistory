class BroadcastsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project, :only => [:new, :create]
  before_filter :setup_project_not_protected, :only => [:index]
  
  def index
    if @project
      @broadcasts_in_progress = @project.broadcasts.in_progress.by_start.limit(10)
      @future_broadcasts = @project.broadcasts.future.by_start.limit(10).includes(:project)
      @past_broadcasts = @project.broadcasts.past.by_start.limit(10).includes(:project)      
    else
      @broadcasts_in_progress = Broadcast.in_progress.by_start.limit(5)
      @broadcasts = Broadcast.by_start.limit(200).includes(:project)
    end    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @broadcasts }
    end
  end

  def show
    @broadcast = Broadcast.find(params[:id])
    @can_edit_project = @broadcast.project.can_edit?(current_user)
    setup_will_paginate
    @per_page = 100
    @scheduled_items = @broadcast.scheduled_items.by_send.includes(:item).paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @broadcast }
    end
  end

  def new
    @first_item = @project.items.by_event_date_time.first
    current = DateTime.now + 1.day
    start_at = DateTime.new(current.year, current.month, current.day, @first_item.event_date_time.hour, @first_item.event_date_time.min) 
    @broadcast = @project.broadcasts.build(:start_at => start_at)
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
    schedule_success = @broadcast.build_schedule
    if success
      flash[:notice] = translate('broadcasts.create_success')
      if !schedule_success
        flash[:notice] = "The broadcast was successfully created but there were some problems creating the broadcast schedule."
      end
    end
    respond_to do |format|
      if success
        format.html { redirect_to(@broadcast) }
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
    @project = @broadcast.project
    @broadcast.destroy
    respond_to do |format|
      format.html { redirect_to(project_broadcasts_path(@project), :notice => 'Broadcast was successfully deleted') }
      format.xml  { head :ok }
    end
  end
  
  protected
    def check_permissions
      redirect_to(@project, :notice => "You don't have rights to change broadcast information for #{@broadcast.project.title}") unless @broadcast.project.can_edit?(current_user)
    end
end
