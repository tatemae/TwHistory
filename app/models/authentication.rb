class Authentication < ActiveRecord::Base
  belongs_to :authenticatable, :polymorphic => true
end
