class ProjectsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  
  def index
    @per_page = 5
    @projects = Project.by_newest.includes(:user).paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects }
    end
  end

  def show
    @project = Project.includes(:characters).find(params[:id])
    @characters = @project.characters
    @items = @project.items.includes(:character)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
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

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
