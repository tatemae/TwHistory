class Broadcast < ActiveRecord::Base
  belongs_to :project
  has_one :authentication, :as => :authenticatable, :dependent => :destroy
  has_many :scheduled_items
  
  scope :by_start, order("broadcasts.start_at DESC")
  scope :past, where("broadcasts.end_at <= ?", DateTime.now)
  scope :in_progress, where("broadcasts.start_at <= ? AND broadcasts.end_at >= ?", DateTime.now, DateTime.now)
  scope :future, where("broadcasts.start_at >= ?", DateTime.now)
  
  scope :by_newest, order("broadcasts.created_at DESC")
  scope :by_oldest, order("broadcasts.created_at ASC")
  scope :by_latest, order("broadcasts.updated_at DESC")
  scope :newer_than, lambda { |*args| where("broadcasts.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("broadcasts.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  def parse_start_at(params)
    self.start_at = DateTime.parse("#{params[:start_date]} #{params[:start_time]}")
  end
  
end
