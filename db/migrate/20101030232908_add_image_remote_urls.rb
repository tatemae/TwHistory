class AddImageRemoteUrls < ActiveRecord::Migration
  def self.up
    add_column :projects, :image_remote_url, :string
    add_column :characters, :image_remote_url, :string
    add_column :items, :image_remote_url, :string
  end

  def self.down
    remove_column :projects, :image_remote_url
    remove_column :characters, :image_remote_url
    remove_column :items, :image_remote_url
  end
end


