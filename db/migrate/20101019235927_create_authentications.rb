class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :token
      t.string :secret
      t.timestamps
    end
    add_index :authentications, [:authenticatable_id, :authenticatable_type]
  end

  def self.down
    drop_table :authentications
  end
end