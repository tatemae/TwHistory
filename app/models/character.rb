class Character < ActiveRecord::Base
  has_one :authentication, :as => :authenticatable, :dependent => :destroy
  has_many :items
  belongs_to :project
  
  scope :by_name, order("name ASC")
  scope :by_newest, order("characters.created_at DESC")
  scope :by_oldest, order("characters.created_at ASC")
  scope :by_latest, order("characters.updated_at DESC")
  scope :newer_than, lambda { |*args| where("characters.created_at > ?", args.first || DateTime.now) }
  scope :older_than, lambda { |*args| where("characters.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
  
  validates_presence_of :name
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
  
end
