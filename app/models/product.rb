class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales

  def price
    values = Sale.where(product_code: self.code).pluck(:price)
    BigDecimal(values.sum / values.length)
    ## It uses (non-weighted) average price between all of its sales
  end

  def husband_product
    ## Best product for a panoplie, maybe?
    best_pair[0]
  end

  def total_sales
    ## Total number of sold Products
    Sale.where(product_code: self.code).pluck(:quantity).sum
  end

  def best_pair(pairs_number = 10)
    ## That's not so simple
    product_sales_transation_codes = Sale.where(product_code: self.code).pluck(:transaction_code)
    ## Every transaction which contains self
    product_sales_panoplie_codes = Sale.where(transaction_code: product_sales_transation_codes).pluck(:product_code)
    ## Every product that has been sold with self
    product_sales_panoplie_codes.group_by(&:itself).values.sort_by(&:size).map(&:uniq).reverse[0...pairs_number].map(&:first) - [self.code]
    ## First groups products to create arrays of number of appearance, then sorts for size and uniq,
    ## then returns an array of codes subtracting the product itself for obvious reasons
  end
end
