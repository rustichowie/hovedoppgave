class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :card_value

      t.timestamps
    end
    add_index :cards, :user_id
  end
end
