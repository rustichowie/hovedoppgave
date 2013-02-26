class ChangeColumnUserIdInWorkhours < ActiveRecord::Migration
  def up
     change_column :workhours, :user_id,  :integer, :null => false
  end

  def down
    change_column :workhours, :user_id,  :integer, :null => true
  end
end
