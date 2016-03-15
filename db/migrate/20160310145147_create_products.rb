class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :code

      t.timestamps null: true
    end
  end
end
