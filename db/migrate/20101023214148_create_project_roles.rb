class CreateProjectRoles < ActiveRecord::Migration
  def self.up
    create_table :project_roles do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :role
      t.timestamps
    end
    add_index :project_roles, :project_id
    add_index :project_roles, :user_id
  end

  def self.down
    drop_table :project_roles
  end
end