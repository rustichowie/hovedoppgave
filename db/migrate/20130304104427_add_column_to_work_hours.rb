class AddColumnToWorkHours < ActiveRecord::Migration
  def change
    add_column :workhours, :approved, :boolean
  end
end
