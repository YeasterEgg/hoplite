class ProductDecorator < ApplicationDecorator
  delegate_all
  delegate :current_page, :total_pages, :limit_value

  def hashed_pairs
    top_pairs.map!{ |array| array = {
                                      product: Product.find(array.first).code,
                                      sales: array.second,
                                      total_worth: array.second * (object[:price] + Product.find(array.first)[:price])
                                    }
    }
  end

  def husband_product
    ## Best product for a panoplie, maybe?
    hashed_pairs[0] || {product: 'Nessuno', sales: ''}
  end

  def values_for_charts
    values = []
    values << best_pairs_to_chart
    values << values_for_pie_chart
  end

    private

    def top_pairs(pair_number = 30)
      all_sales = []
      object.tickets.each do |ticket|
        ticket.sales.where.not(product_id: object[:id]).map{|sale| all_sales << sale[:product_id]}
      end
      counted_sales = Hash.new(0)
      all_sales.each do |sale|
        counted_sales[sale] += 1
      end
      counted_sales.sort_by{ |key,value| value}
                   .last(pair_number)
                   .reverse
      CACCA
    end

    def best_pairs_to_chart(pairs_number = 10)
      best_pairs = hashed_pairs.first(pairs_number)
      best_pairs_to_chart = [
                            ["Prodotto", "Quantità",{ role: 'style' }]
                          ]
      best_pairs.each do |pair|
        sales_vs_best = pair[:sales] / best_pairs[0][:sales]
        intensity = (255 * sales_vs_best).round.to_s(16)
        best_pairs_to_chart << [pair[:product], pair[:sales], "#0000#{intensity}"]
      end
      best_pairs_to_chart
    end

    def values_for_pie_chart
      ticket_by_size.unshift(['Quantità nello scontrino', 'Ripetizioni'])
    end

    def ticket_by_size
      counted_tickets = Hash.new(0)
      object.tickets.map{ |ticket| ticket.products.size }.each do |ticket|
        counted_tickets["#{ticket} quantità"] += 1
      end
      counted_tickets.to_a
    end

end
