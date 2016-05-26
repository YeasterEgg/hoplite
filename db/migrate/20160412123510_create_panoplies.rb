class CreatePanoplies < ActiveRecord::Migration
  def change
    create_table :panoplies do |t|
      t.integer :product_id_1
      t.integer :product_id_2
      ## Basic values
      t.integer :quantity
      t.integer :solo_sales
      ## Coefficients
      t.float :correlation_factor
      t.float :real_probable_factor
      t.float :money_factor
      t.float :perfect_sales_factor
      ## Importance
      t.float :importance
    end
  end
end
