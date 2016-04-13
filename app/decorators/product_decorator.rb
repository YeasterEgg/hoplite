class ProductDecorator < ApplicationDecorator
  delegate_all
  delegate :current_page, :total_pages, :limit_value

  def hashed_pairs
    hashed_pairs = []
    panoplies_product_1.each do |panoplie|
      product_2 = Product.find(panoplie[:product_id_2])
      hashed_pairs << {
                    product: product_2[:code],
                    sales: panoplie[:quantity],
                    total_worth: panoplie[:quantity] * (object[:price] + product_2[:price])
                    }
    end
    panoplies_product_2.each do |panoplie|
      product_2 = Product.find(panoplie[:product_id_1])
      hashed_pairs << {
                    product: product_2[:code],
                    sales: panoplie[:quantity],
                    total_worth: panoplie[:quantity] * (object[:price] + product_2[:price])
                    }
    end
    hashed_pairs.sort_by{|pair| pair[:sales]}.reverse
  end

  def husband_product
    ## Best product for a panoplie, maybe?
    hashed_pairs[0] || {product: 'Nessuno', sales: ''}
  end

  def values_for_charts
    values = []
    values << best_pairs_to_chart
    values << values_for_pie_chart
    values << values_for_scatterplot
  end

    private

    def top_pairs(pair_number = 30)
      all_sales = []
      object.tickets.each do |ticket|
        ticket.sales.where.not(product_id: object[:id]).map{|sale| all_sales << sale}
      end
      counted_sales = Hash.new(0)
      all_sales.uniq(&:ticket_id).map(&:product_id).each do |sale|
        counted_sales[sale] += 1
      end
      counted_sales.sort_by{ |key,value| value}
                   .last(pair_number)
                   .reverse
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

    def values_for_scatterplot
      values_for_scatterplot = [["Data", "Vendite"]]
      tickets.group_by(&:date).map{|date,tickets| values_for_scatterplot << [date.strftime("%d/%m/%y"), tickets.size]}
      values_for_scatterplot
    end

    def ticket_by_size
      counted_tickets = Hash.new(0)
      object.tickets.map{ |ticket| ticket.products.size }.each do |ticket|
        counted_tickets["#{ticket} quantità"] += 1
      end
      counted_tickets.to_a
    end

end
