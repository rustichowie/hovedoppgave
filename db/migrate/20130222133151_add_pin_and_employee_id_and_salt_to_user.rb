class AddPinAndEmployeeIdAndSaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :employee_id, :int
    add_column :users, :pin, :string
    add_column :users, :salt, :string
  end
end
