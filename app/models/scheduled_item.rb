class ScheduledItem < ActiveRecord::Base
  belongs_to :broadcast
  belongs_to :item
  
  validates_presence_of :send_at
  
  scope :by_send, order("scheduled_items.send_at DESC")
  
end
