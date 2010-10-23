class ScheduledItemsController < ApplicationController
  # GET /scheduled_items
  # GET /scheduled_items.xml
  def index
    @scheduled_items = ScheduledItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scheduled_items }
    end
  end

  # GET /scheduled_items/1
  # GET /scheduled_items/1.xml
  def show
    @scheduled_item = ScheduledItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scheduled_item }
    end
  end

  # GET /scheduled_items/new
  # GET /scheduled_items/new.xml
  def new
    @scheduled_item = ScheduledItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scheduled_item }
    end
  end

  # GET /scheduled_items/1/edit
  def edit
    @scheduled_item = ScheduledItem.find(params[:id])
  end

  # POST /scheduled_items
  # POST /scheduled_items.xml
  def create
    @scheduled_item = ScheduledItem.new(params[:scheduled_item])

    respond_to do |format|
      if @scheduled_item.save
        format.html { redirect_to(@scheduled_item, :notice => 'Scheduled item was successfully created.') }
        format.xml  { render :xml => @scheduled_item, :status => :created, :location => @scheduled_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scheduled_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scheduled_items/1
  # PUT /scheduled_items/1.xml
  def update
    @scheduled_item = ScheduledItem.find(params[:id])

    respond_to do |format|
      if @scheduled_item.update_attributes(params[:scheduled_item])
        format.html { redirect_to(@scheduled_item, :notice => 'Scheduled item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scheduled_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_items/1
  # DELETE /scheduled_items/1.xml
  def destroy
    @scheduled_item = ScheduledItem.find(params[:id])
    @scheduled_item.destroy

    respond_to do |format|
      format.html { redirect_to(scheduled_items_url) }
      format.xml  { head :ok }
    end
  end
end
