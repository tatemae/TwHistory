class CreateBroadcasts < ActiveRecord::Migration
  def self.up
    create_table :broadcasts do |t|
      t.integer :project_id
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.datetime :start_at
      t.timestamps
    end
    add_index :broadcasts, :project_id
  end

  def self.down
    drop_table :broadcasts
  end
end
