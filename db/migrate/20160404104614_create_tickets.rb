class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :quantity
      t.datetime :date
      t.decimal :total_worth, precision: 7, scale: 2
      t.string :code
      t.boolean :read, default: false
    end
  end
end
