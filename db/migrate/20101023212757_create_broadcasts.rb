class CreateBroadcasts < ActiveRecord::Migration
  def self.up
    create_table :broadcasts do |t|
      t.integer :project_id
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
    add_index :broadcasts, :project_id
  end

  def self.down
    drop_table :broadcasts
  end
end
