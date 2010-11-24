class ScheduledItemsController < ApplicationController

  def update
    # TODO update should send back ajax that updates the form and indicates the scheduled item was updated
    @scheduled_item = ScheduledItem.find(params[:id])
    @scheduled_item.parse_run_at(params)
    respond_to do |format|
      if @scheduled_item.save
        format.html { redirect_to(@scheduled_item, :notice => 'Scheduled item was successfully updated.') }
        format.js { render :text => "jQuery('#errorExplanation').html('Scheduled tweet was successfully updated.');jQuery('#errorExplanation').show();" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { render :text => "jQuery('#errorExplanation').html('Scheduled tweet could not be updated.');jQuery('#errorExplanation').show();" }
        format.xml  { render :xml => @scheduled_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    # TODO destroy should remove the item from the list
    @scheduled_item = ScheduledItem.find(params[:id])
    @scheduled_item.destroy
    respond_to do |format|
      format.html { redirect_to(scheduled_items_url) }
      format.xml  { head :ok }
    end
  end

end
