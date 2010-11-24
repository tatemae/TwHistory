class MoveTweetsToDj < ActiveRecord::Migration
  def self.up
    remove_column :items, :tweet_id
    add_column :delayed_jobs, :broadcast_id, :integer
    add_column :delayed_jobs, :item_id, :integer
    drop_table :scheduled_items
  end

  def self.down
    add_column :items, :tweet_id, :integer
    add_column :delayed_jobs, :broadcast_id
    add_column :delayed_jobs, :item_id
    create_table "scheduled_items", :force => true do |t|
      t.integer  "broadcast_id"
      t.integer  "item_id"
      t.datetime "send_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
