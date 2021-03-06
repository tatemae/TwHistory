class CharactersController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project, :except => [:index, :show, :destroy]
  before_filter :setup_project_not_protected, :only => [:index]
  
  def index
    if @project
      @characters = @project.characters
    else
      redirect_to root_path
      return
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  def show
    setup_will_paginate
    @character = Character.find(params[:id])
    @project ||= @character.project
    @items = @character.items.chronological.paginate(:page => @page, :per_page => @per_page)
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
    @can_edit_project = @character.project.can_edit?(current_user)
  end

  def create
    @character = @project.characters.build(params[:character])
    respond_to do |format|
      if @character.save
        format.html { redirect_to(project_characters_path(@project), :notice => translate('characters.create_success')) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @character = @project.characters.find(params[:id])
    success = @character.update_attributes(params[:character])
    @character.twitter_update
    respond_to do |format|
      if success
        format.html { redirect_to( project_characters_path(@project), :notice => translate('characters.update_success')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @project = @character.project
    @character.destroy
    respond_to do |format|
      format.html { redirect_to(@project) }
      format.xml  { head :ok }
    end
  end
    
end
