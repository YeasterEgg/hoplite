class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.string :website
      t.string :web_pic
      t.integer :total_sales
      t.decimal :price, precision: 6, scale: 2

      t.timestamps null: true
    end
  end
end
