class ScheduledItemsController < ApplicationController

  def update
    @scheduled_item = ScheduledItem.find(params[:id])
    @scheduled_item.parse_run_at(params)
    respond_to do |format|
      if @scheduled_item.save
        format.html { redirect_to(@scheduled_item, :notice => 'Scheduled item was successfully updated.') }
        format.js { render :js => "jQuery('##{@scheduled_item.dom_id}_message').html('Successfully updated.');" }        
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { render :js => "jQuery('##{@scheduled_item.dom_id}_message').html('Could not be updated.');" }
        format.xml  { render :xml => @scheduled_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @scheduled_item = ScheduledItem.find(params[:id])
    @broadcast = @scheduled_item.broadcast
    @scheduled_item.destroy
    respond_to do |format|
      format.html { redirect_to(@broadcast) }
      format.xml { head :ok }
      format.js { render :js => "jQuery('##{@scheduled_item.dom_id}').fadeOut();" }
    end
  end

end
