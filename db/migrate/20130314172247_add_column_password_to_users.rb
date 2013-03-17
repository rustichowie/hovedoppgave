class AddColumnPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password, :string, :null => false
  end
end
