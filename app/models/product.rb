class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales

  def price
    values = Sale.where(product_code: self.code).pluck(:price)
    BigDecimal(values.sum / values.length)
  end

  def husband_product
    best_pair[0]
  end

  def total_sales
    Sale.where(product_code: self.code).pluck(:quantity).sum
  end

  def best_pair(pairs_number = 10)
    product_sales_transation_codes = Sale.where(product_code: self.code).pluck(:transaction_code)
    product_sales_panoplie_codes = Sale.where(transaction_code: product_sales_transation_codes).pluck(:product_code)
    product_sales_panoplie_codes.group_by(&:itself).values.sort_by(&:size).map(&:uniq).reverse[0...pairs_number].map(&:first)
  end
end
