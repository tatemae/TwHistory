class BroadcastsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project
  
  def index
    @broadcasts = Broadcast.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @broadcasts }
    end
  end

  # GET /broadcasts/1
  # GET /broadcasts/1.xml
  def show
    @broadcast = Broadcast.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @broadcast }
    end
  end

  # GET /broadcasts/new
  # GET /broadcasts/new.xml
  def new
    @broadcast = Broadcast.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @broadcast }
    end
  end

  # GET /broadcasts/1/edit
  def edit
    @broadcast = Broadcast.find(params[:id])
  end

  # POST /broadcasts
  # POST /broadcasts.xml
  def create
    @broadcast = Broadcast.new(params[:broadcast])

    respond_to do |format|
      if @broadcast.save
        format.html { redirect_to(@broadcast, :notice => 'Broadcast was successfully created.') }
        format.xml  { render :xml => @broadcast, :status => :created, :location => @broadcast }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @broadcast.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /broadcasts/1
  # PUT /broadcasts/1.xml
  def update
    @broadcast = Broadcast.find(params[:id])

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

  # DELETE /broadcasts/1
  # DELETE /broadcasts/1.xml
  def destroy
    @broadcast = Broadcast.find(params[:id])
    @broadcast.destroy

    respond_to do |format|
      format.html { redirect_to(broadcasts_url) }
      format.xml  { head :ok }
    end
  end
end
