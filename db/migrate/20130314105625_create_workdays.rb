class CreateWorkdays < ActiveRecord::Migration
  def change
    create_table :workdays do |t|
      t.datetime :date
      t.integer :user_id
      t.string :comment
      t.integer :supervisor_hour
      t.boolean :approved

      t.timestamps
    end
  end
end
