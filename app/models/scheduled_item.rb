class ScheduledItem < ActiveRecord::Base
  set_table_name "delayed_jobs"
  belongs_to :broadcast
  belongs_to :item
  
  scope :by_send, order("delayed_jobs.run_at ASC")
  scope :ready_to_send, where("delayed_jobs.run_at <= ?", DateTime.now.getutc)
  
  def parse_run_at(params)
    self.run_at = DateTime.parse("#{params[:run_date]} #{params[:run_time]}")
  end
  
  attr_accessible :run_at
end
