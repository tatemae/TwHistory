class Character < ActiveRecord::Base
  has_many :authentications, :as => :authenticatable, :dependent => :destroy
  has_many :items
  belongs_to :project
  
  scope :by_name, order("name ASC")
  
  validates_presence_of :name
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :icon => "62x62>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/character_default.jpg"
  
end
