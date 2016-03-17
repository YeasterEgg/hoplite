class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :code
      t.integer :total_sales
      t.string :name
      t.decimal :price

      t.timestamps null: true
    end
  end
end
