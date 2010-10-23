class Broadcast < ActiveRecord::Base
  belongs_to :project
  has_one :authentication, :as => :authenticatable, :dependent => :destroy
  has_many :scheduled_items
end
