class CreateSoldProducts < ActiveRecord::Migration
  def change
    create_table :sold_products do |t|
      t.integer :sale_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
