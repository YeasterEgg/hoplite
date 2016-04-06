class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales
  has_many :tickets, through: :sales

  def to_param
    code
  end

  def total_worth
    self[:total_sales] * self[:price]
  end

  private

    def new_price_average(last_price)
      (self[:price] * self[:total_sales] + last_price.to_f) / (self[:total_sales]+1)
    end

end
