class AddRoleIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer, null: false
    add_index :users, :role_id
  end
end
