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
    best_pair[0] || {product: 'Nessuno', sales: ''}
  end

  def best_pair(pairs_number = 10)
    ## That's not so simple
    product_sales_transation_codes = Sale.where(product_code: self.code).pluck(:transaction_code)
    ## Every transaction which contains self
    product_sales_panoplie_codes = Sale.where(transaction_code: product_sales_transation_codes)
                                       .where.not(product_code: self.code)
                                       .pluck(:product_code)
    ## Every sale that contains self but those about self
    sort_and_count(product_sales_panoplie_codes)
  end

  def find_out_name
    ## It works only with live products, also it's really unstable + product names SUCKS.
    ## That said, it's quick&dirty, but better than nothing
    product_url = URI("http://www.decathlon.it/Comprare/#{self.code}")
    response_to_url = Net::HTTP.get_response(product_url)
    response_to_url['location'].nil? ? 'ProdottoInattivo' : parse_product_title(response_to_url['location'])
  end

  private

    def parse_product_title(title)
      title.split('-id_')[0].split('/')[-1].gsub('-',' ').capitalize
      ## I know, it's bad. There surely are better solutions, but I'm quite curious to test it, I will
      ## refactor later (as in never)
    end

    def sort_and_count(bi_array)
      ## IF AND WHEN I SORT IT OUT, FIX THE SORT AND REVERSE
      bi_array.group_by(&:itself)
              .values
              .sort_by(&:size)
              .reverse
              .map{|array| array = {product: array.uniq.first, sales: array.length}}
      ## Groups products to create arrays of number of appearance, then sorts for size and create
      ## for each product a hash with product = product.code and sales = times of sales together
    end
end
