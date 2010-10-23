class CharactersController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project
  
  def index
    @characters = @project.characters
    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  def show
    @character = @project.characters.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @character }
    end
  end

  def new
    @character = Character.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @character }
    end
  end

  def edit
    @character = Character.find(params[:id])
  end

  def create
    @character = @project.characters.build(params[:character])
    respond_to do |format|
      if @character.save
        format.html { redirect_to(@project, :notice => 'Character was successfully created.') }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @character = @project.characters.find(params[:id])
    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to(@character, :notice => 'Character was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @character.destroy
    respond_to do |format|
      format.html { redirect_to(characters_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def setup_project
      @project = Project.find(params[:project_id])
      if !@project.can_edit?(current_user)
        flash[:notice] = translate('projects.edit_permission_denied', :project_title => @project.title)
        redirect_to @project
      end
    end
    
end
