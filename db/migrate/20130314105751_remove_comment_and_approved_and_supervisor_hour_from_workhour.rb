class RemoveCommentAndApprovedAndSupervisorHourFromWorkhour < ActiveRecord::Migration
  def up
    remove_column :workhours, :comment
    remove_column :workhours, :approved
    remove_column :workhours, :supervisor_hour
  end

  def down
  end
end
