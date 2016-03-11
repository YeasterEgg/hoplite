class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :code
      t.float :decimal

      t.timestamps null: true
    end
  end
end
