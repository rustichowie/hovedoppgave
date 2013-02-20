class AddUniqueIndexToCard < ActiveRecord::Migration
  def change
    add_index :cards, [:user_id, :card_value], :unique => true
  end
end
