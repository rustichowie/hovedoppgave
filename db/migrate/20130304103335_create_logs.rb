class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.integer :card_id
      t.integer :logtype_id
      t.integer :workhours_id

      t.timestamps
    end
    
    
    add_index :logs, :logtype_id
  end
end
