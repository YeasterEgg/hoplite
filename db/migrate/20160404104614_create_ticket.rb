class CreateTicket < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :quantity
      t.datetime :date
      t.decimal :total_worth, precision: 5, scale: 2
    end
  end
end
