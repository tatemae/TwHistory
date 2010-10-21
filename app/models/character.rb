class Character < ActiveRecord::Base
  has_many :authentications
  has_many :items
  belongs_to :project
  
  scope :by_name, order("name ASC")
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "50x50>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/profile_default.jpg"
  
end
