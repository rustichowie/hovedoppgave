class AddColumnWorkDayIdAndEffectedUserIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :workday_id, :integer
    add_column :logs, :effected_user_id, :integer
  end
end
