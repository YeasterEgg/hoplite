class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.datetime :date
      t.integer :transaction_code
      t.integer :quantity
      t.integer :product_code
      t.boolean :checked

      t.timestamps null: true
    end
  end
end
