class AddCommentAndSupervisorHourToWorkhours < ActiveRecord::Migration
  def change
    add_column :workhours, :comment, :text
    add_column :workhours, :supervisor_hour, :integer
  end
end
