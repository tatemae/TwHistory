class AddPhotoRemoteUrls < ActiveRecord::Migration
  def self.up
    add_column :projects, :photo_remote_url, :string
    add_column :characters, :photo_remote_url, :string
    add_column :items, :photo_remote_url, :string
  end

  def self.down
    remove_column :projects, :photo_remote_url
    remove_column :characters, :photo_remote_url
    remove_column :items, :photo_remote_url
  end
end


