class AddSharedByType < ActiveRecord::Migration
  def self.up
    add_column :shares, :shared_by_type, :string
  end

  def self.down
    remove_column :shares, :shared_by_type
  end
end