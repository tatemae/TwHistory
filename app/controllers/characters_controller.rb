class CharactersController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project, :except => [:index, :show, :destroy]
  before_filter :setup_project_not_protected, :only => [:show, :index]
  
  def index
    @characters = @project.characters
    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters }
    end
  end

  def show
    setup_will_paginate
    @character = @project.characters.find(params[:id])
    @items = @character.items.by_newest.paginate(:page => @page, :per_page => @per_page)
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
        format.html { redirect_to(@project, :notice => translate('characters.create_success')) }
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
