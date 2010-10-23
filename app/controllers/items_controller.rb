class ItemsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  before_filter :setup_project
  
  def index
    @items = @project.items.by_newest
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def new
    @item = @project.items.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end
  
  def create
    if params[:item][:csv]
      @project.import_items(params[:item][:csv])
    else
      @item = Item.new(params[:item])
      @item.parse_event_date_time(params)
    end
    respond_to do |format|
      if @item.save
        format.html { redirect_to(@item, :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    @item.parse_event_date_time(params)

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
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
