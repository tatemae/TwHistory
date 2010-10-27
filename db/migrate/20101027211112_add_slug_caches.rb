class AddSlugCaches < ActiveRecord::Migration
  def self.up
    add_column :projects, :cached_slug, :string
    add_index  :projects, :cached_slug, :unique => true

    add_column :characters, :cached_slug, :string
    add_index  :characters, :cached_slug, :unique => true
  end

  def self.down
    remove_column :projects, :cached_slug
    remove_column :characters, :cached_slug
  end
end