class ScheduledItemsController < ApplicationController

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

  def destroy
    @scheduled_item = ScheduledItem.find(params[:id])
    @scheduled_item.destroy
    respond_to do |format|
      format.html { redirect_to(scheduled_items_url) }
      format.xml  { head :ok }
    end
  end

end
