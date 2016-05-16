class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales
  has_many :tickets, through: :sales

  has_many :panoplies_product_1, foreign_key: "product_id_1", class_name: "Panoplie"
  has_many :panoplies_product_2, foreign_key: "product_id_2", class_name: "Panoplie"

  scope :unnamed, -> { where(name: nil) }
  scope :named, -> { where.not(name: nil) }


  def to_param
    code
  end

  def total_worth
    self[:total_sales] * self[:price]
  end

  def new_price_average(last_price)
    (self[:price] * self[:total_sales] + last_price.to_f) / (self[:total_sales]+1)
  end

  def panoplies
    panoplies_product_1 + panoplies_product_2
  end

end
