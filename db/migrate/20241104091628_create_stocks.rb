class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false
      t.timestamps
    end

    add_index :stocks, :symbol, unique: true
  end
end
