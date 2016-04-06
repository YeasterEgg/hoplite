class Product < ActiveRecord::Base

  require 'bigdecimal'

  has_many :sales
  has_many :tickets, through: :sales

  def to_param
    code
  end

  def husband_product
    ## Best product for a panoplie, maybe?
    top_pairs[0] || {product: 'Nessuno', sales: ''}
  end

  def total_worth
    self[:total_sales] * self[:price]
  end

  def product_pairs
    top_pairs.hashed
  end

  private

    def top_pairs(pair_number = 30)
      all_sales = []
      self.tickets.each do |ticket|
        ticket.sales.where.not(product_id: self[:id]).map{|sale| all_sales << sale.product.code}
      end
      all_sales.each{ |key,value| all_sales[key] =  value.size}
               .sort_by{ |key,value| value}
               .last(pair_number)
               .reverse
    end

    def set_name_and_website
      params = find_out_name
      self.update_attributes(name: params[:name], website: params[:website])
    end

    def new_price_average(last_price)
      (self[:price] * self[:total_sales] + last_price.to_f) / (self[:total_sales]+1)
    end

    def values_for_charts
      values = []
      values << best_pairs_to_chart
      values << values_for_pie_chart
    end

    def best_pairs_to_chart(pairs_number = 10)
      best_pairs = all_pairs.shift(pairs_number)
      best_pairs_to_chart = [
                            ["Prodotto", "Quantità",{ role: 'style' }]
                          ]
      best_pairs.each do |pair|
        sales_vs_best = pair[:sales] / best_pairs[0][:sales]
        intensity = (255 * sales_vs_best).round.to_s(16)
        best_pairs_to_chart << [pair[:product].to_s, pair[:sales], "#0000#{intensity}"]
      end
      best_pairs_to_chart
    end

    def values_for_pie_chart
      values_for_pie_chart = ticket_by_size.unshift(['Quantità nello scontrino', 'Ripetizioni'])
    end

    def find_out_name
      ## It works only with live products, also it's really unstable + product names SUCKS.
      ## That said, it's FUCKINGSLOW&dirty, still better than nothing
      product_url = URI("http://www.decathlon.it/Comprare/#{self.code}")
      response_to_url = Net::HTTP.get_response(product_url)
      if response_to_url['location']
        return {
                name: parse_product_title(response_to_url['location']),
                website: response_to_url['location'],
               }
      else
        return {
                name: 'ProdottoInattivo',
                website: 'http:://www.decathlon.it',
               }
      end
    end

    def parse_product_title(title)
      ## I know, it's bad. There surely are better solutions, but I'm quite curious to test it, I will
      ## refactor later (as in never)
      title.split('-id_')[0].split('/')[-1].gsub('-',' ').capitalize
    end

    def hashed
      ## IF AND WHEN I SORT IT OUT, FIX THE SORT AND REVERSE
      ## Groups products to create arrays of number of appearance, then sorts for size and create
      ## for each product a hash with product = product.code, sales = times of sales together and
      ## total_worth = combined value of all panoplie sales
      bi_array.group_by(&:itself)
              .values
              .sort_by(&:size)
              .reverse
              .map{|array| array = {product: array.uniq.first,
                                    sales: array.length,
                                    total_worth: array.length * (self[:price] + Product.find_by_code(array.uniq.first)[:price])
                                    }
                    }
    end

end
