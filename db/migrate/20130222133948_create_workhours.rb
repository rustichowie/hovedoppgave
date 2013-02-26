class CreateWorkhours < ActiveRecord::Migration
  def change
    create_table :workhours do |t|
      t.timestamp :start
      t.timestamp :stop
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
    add_index :workhours, :user_id
  end
end
