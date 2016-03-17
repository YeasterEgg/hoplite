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
    all_pairs[0] || {product: 'Nessuno', sales: ''}
  end

  def all_pairs
    ## That's not so simple
    product_sales_dates = Sale.where(product_code: self.code).pluck(:date)
    ## Every transaction which contains self (transactions are identified via date)
    product_sales_panoplie_codes = Sale.where(date: product_sales_dates)
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

  def best_pairs_to_chart(pairs_number = 20)
    best_pairs = all_pairs.shift(pairs_number)
    others = all_pairs.map{|panoplie| panoplie[:sales]}.sum
    best_pairs_to_chart = [
                          ["Prodotto", "Quantità",{ role: 'style' }]
                        ]
    best_pairs_to_chart << ["Solo", solo_transactions, "#FF0000"]
    best_pairs.each do |pair|
      sales_vs_best = pair[:sales] / best_pairs[0][:sales]
      intensity = (255 * sales_vs_best).round.to_s(16)
      best_pairs_to_chart << [pair[:product].to_s, pair[:sales], "#0000#{intensity}"]
    end
    best_pairs_to_chart << ["Altri", others, "#00FF00"]
    best_pairs_to_chart
  end

  def values_for_pie_chart
    values_for_pie_chart = [
                          ['Prodotto', 'Quantità']
                        ]
    values_for_pie_chart << ['Solo', solo_transactions]
    values_for_pie_chart << ['In Panoplie', total_transactions - solo_transactions]
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

    def total_transactions
      Sale.where(product_code: self.code).size
    end

    def solo_transactions
      product_sales_dates = Sale.where(product_code: self.code).pluck(:date)
      solo_transactions = 0
      product_sales_dates.each do |date|
        if Sale.where(date: date).size == 1
          solo_transactions += 1
        end
      end
      solo_transactions
    end
end
