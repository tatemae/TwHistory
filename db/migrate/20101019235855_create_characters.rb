class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :project_id
      t.string :name
      t.text :bio
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.timestamps
    end
    add_index :characters, :project_id
  end

  def self.down
    drop_table :characters
  end
end
