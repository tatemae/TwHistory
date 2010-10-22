class Project < ActiveRecord::Base
  has_many :authentications, :as => :authenticatable, :dependent => :destroy
  has_many :characters
  has_many :items
  belongs_to :user
  
  scope :by_newest, order("projects.created_at DESC")
  scope :by_oldest, order("projects.created_at ASC")
  scope :by_latest, order("projects.updated_at DESC")
  scope :newer_than, lambda { |*args| where("projects.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("projects.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  has_friendly_id :title
  
  def can_edit?(check_user)
    return false if check_user.blank?
    check_user == self.user
  end
  
end
