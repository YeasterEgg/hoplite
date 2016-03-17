class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.datetime :date
      t.integer :quantity
      t.integer :product_code
      t.decimal :price,  precision: 5, scale: 2
      t.boolean :checked

      t.timestamps null: true
    end
  end
end
