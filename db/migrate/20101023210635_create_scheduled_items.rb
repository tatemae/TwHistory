class CreateScheduledItems < ActiveRecord::Migration
  def self.up
    create_table :scheduled_items do |t|
      t.integer :broadcast_id
      t.integer :item_id
      t.datetime :send_at
      t.timestamps
    end
  end

  def self.down
    drop_table :scheduled_items
  end
end
