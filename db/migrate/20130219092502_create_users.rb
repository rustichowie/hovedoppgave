class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_id
      t.integer :sosial_security_number

      t.timestamps
    end
  end
end
