class DropColumnUserIdAndCardIdAndWorkhoursIdAndWorkdayIdAndEffectedUserIdFromLogs < ActiveRecord::Migration
  def up
    remove_column :logs, :action
  end

  def down
  end
end
