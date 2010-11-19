class ProjectsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  
  def index
    @per_page = 5
    setup_will_paginate
    @projects = Project.by_newest.includes(:user).paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects }
    end
  end

  def show
    @project = Project.includes(:characters).find(params[:id])
    @characters = @project.characters.by_newest.limit(10)
    @items = @project.items.includes(:character).chronological.limit(10)
    @upcoming_broadcasts = @project.broadcasts.current_and_future.limit(10)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = current_user.projects.build(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    
    if(params[:mark_featured])
      if current_user.admin?
        if @project.items.length > 0
          @project.featured_at = DateTime.now
          success = @project.save
          message = 'Re-enactment was marked as featured.' if success
        else
          success = true
          message = "Coudn't mark Re-enactment as featured. It doesn't have any historical events yet."
        end
      end
    elsif(params[:unmark_featured])
      if current_user.admin?
        @project.featured_at = nil
        success = @project.save
        message = 'Re-enactment featured status has been removed.' if success
      end
    else
      success = @project.update_attributes(params[:project])
      message = 'Project was successfully updated.' if success
    end
    respond_to do |format|
      if success
        format.html { redirect_to(@project, :notice => message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    stuff_deleted = false

    if params[:items]
      @project.items.destroy_all
      stuff_deleted = true
    end
      
    if params[:characters]
      @project.characters.destroy_all
      stuff_deleted = true
    end
    
    @project.destroy unless stuff_deleted

    respond_to do |format|
      format.html do
        if stuff_deleted
          redirect_to(project_url(@project))
        else
          redirect_to(projects_url)
        end
      end
      format.xml  { head :ok }
    end
  end
end
