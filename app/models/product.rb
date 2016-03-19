class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales

  def husband_product
    ## Best product for a panoplie, maybe?
    all_pairs[0] || {product: 'Nessuno', sales: ''}
  end

  def all_pairs
    ## That's not so simple
    ## Every transaction which contains self (transactions are identified via date)
    product_sales_dates = Sale.where(product_code: self.code).pluck(:date)
    ## Every sale that contains self but those about self
    product_sales_panoplie_codes = Sale.where(date: product_sales_dates)
                                       .where.not(product_code: self.code)
                                       .pluck(:product_code)
    sort_and_count(product_sales_panoplie_codes)
  end

  def set_name
    self.update_attribute(:name, find_out_name)
  end

  def best_pairs_to_chart(pairs_number = 20)
    best_pairs = all_pairs.shift(pairs_number)
    best_pairs_to_chart = [
                          ["Prodotto", "Quantità",{ role: 'style' }]
                        ]
    best_pairs_to_chart << ["Solo", solo_transactions, "#FF0000"]
    best_pairs.each do |pair|
      sales_vs_best = pair[:sales] / best_pairs[0][:sales]
      intensity = (255 * sales_vs_best).round.to_s(16)
      best_pairs_to_chart << [pair[:product].to_s, pair[:sales], "#0000#{intensity}"]
    end
    best_pairs_to_chart
  end

  def values_for_pie_chart
    values_for_pie_chart = [
                          ['Prodotto', 'Quantità']
                        ]
    values_for_pie_chart << ['Solo', solo_transactions]
    values_for_pie_chart << ['In Panoplie', total_transactions - solo_transactions]
  end

  def new_price_average(last_price)
    (self[:price] * self[:total_sales] + last_price.to_f) / (self[:total_sales]+1)
  end

  private

    def find_out_name
      ## It works only with live products, also it's really unstable + product names SUCKS.
      ## That said, it's FUCKINGSLOW&dirty, still better than nothing
      product_url = URI("http://www.decathlon.it/Comprare/#{self.code}")
      response_to_url = Net::HTTP.get_response(product_url)
      response_to_url['location'].nil? ? 'ProdottoInattivo' : parse_product_title(response_to_url['location'])
    end

    def parse_product_title(title)
      ## I know, it's bad. There surely are better solutions, but I'm quite curious to test it, I will
      ## refactor later (as in never)
      title.split('-id_')[0].split('/')[-1].gsub('-',' ').capitalize
    end

    def sort_and_count(bi_array)
      ## IF AND WHEN I SORT IT OUT, FIX THE SORT AND REVERSE
      ## Groups products to create arrays of number of appearance, then sorts for size and create
      ## for each product a hash with product = product.code and sales = times of sales together
      bi_array.group_by(&:itself)
              .values
              .sort_by(&:size)
              .reverse
              .map{|array| array = {product: array.uniq.first, sales: array.length}}
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
