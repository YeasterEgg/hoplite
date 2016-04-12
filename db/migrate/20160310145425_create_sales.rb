class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :quantity
      t.decimal :price, precision: 6, scale: 2
      t.integer :ticket_id
      t.integer :product_id
    end
  end
end
