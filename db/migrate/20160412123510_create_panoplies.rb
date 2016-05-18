class CreatePanoplies < ActiveRecord::Migration
  def change
    create_table :panoplies do |t|
      t.integer :quantity
      t.integer :product_id_1
      t.integer :product_id_2
      t.integer :solo_sales
      t.integer :importance
    end
  end
end
