class ChangeColumnApprovedFromWorkdays < ActiveRecord::Migration
  def up
    remove_column :workdays, :approved
    add_column :workdays, :approved, :boolean, default: false
  end

  def down
  end
end
