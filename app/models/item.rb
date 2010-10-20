class Item < ActiveRecord::Base
  belongs_to :project
  belongs_to :character
end
