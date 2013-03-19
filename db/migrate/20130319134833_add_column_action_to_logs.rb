class AddColumnActionToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :action, :string
  end
end
