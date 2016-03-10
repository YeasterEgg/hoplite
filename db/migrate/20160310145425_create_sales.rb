class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.datetime :date
      t.integer :number
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
