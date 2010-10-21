class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :character_id
      t.integer :project_id
      t.string :content
      t.text :source
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.string :location
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.timestamps
      t.datetime :occured_at
    end
    add_index  :profiles, [:lat, :lng]
  end

  def self.down
    drop_table :items
  end
end