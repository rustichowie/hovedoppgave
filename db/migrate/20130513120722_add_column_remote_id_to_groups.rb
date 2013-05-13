class AddColumnRemoteIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :remote_id, :integer
  end
end
