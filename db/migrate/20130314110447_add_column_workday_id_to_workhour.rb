class AddColumnWorkdayIdToWorkhour < ActiveRecord::Migration
  def change
    add_column :workhours, :workday_id, :integer, null: false
  end
end
