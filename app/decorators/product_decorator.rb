class ProductDecorator < ApplicationDecorator
  delegate_all
  delegate :current_page, :total_pages, :limit_value

  # def hashed_pairs( n = 20 )
  #   hashed_pairs = []
  #   panoplies_product_1.each do |panoplie|
  #     product_2 = Product.find(panoplie[:product_id_2])
  #     hashed_pairs << {
  #                   product: product_2[:code],
  #                   sales: panoplie[:quantity],
  #                   total_worth: panoplie[:quantity] * (object[:price] + product_2[:price]),
  #                   real_probable_ratio: panoplie[:quantity].fdiv(probable_sales(product_2)),
  #                   solo_ticket_ratio: panoplie[:solo_sales].fdiv(panoplie[:quantity]),
  #                   correlation_coefficient: panoplie.correlation_coefficient,
  #                   }
  #   end
  #   panoplies_product_2.each do |panoplie|
  #     product_2 = Product.find(panoplie[:product_id_1])
  #     hashed_pairs << {
  #                   product: product_2[:code],
  #                   sales: panoplie[:quantity],
  #                   total_worth: panoplie[:quantity] * (object[:price] + product_2[:price]),
  #                   real_probable_ratio: panoplie[:quantity].fdiv(probable_sales(product_2)),
  #                   solo_ticket_ratio: panoplie[:solo_sales].fdiv(panoplie[:quantity]),
  #                   correlation_coefficient: panoplie.correlation_coefficient,
  #                   }
  #   end
  #   hashed_pairs.sort_by{|pair| pair[:sales]}.last(n).reverse
  # end

  def values_for_charts
    values = []
    values << best_pairs_to_chart
    values << values_for_pie_chart
    values << values_for_scatterplot
  end

  def complete_date_sales(formatted_time = false, from = object.sales.first.date, to = object.sales.last.date)
    ## Fairly simple explanation, not so much the way it does it!
    ## It needs to fill the void days in the list of sales per day, so that they can be measured better.

    grouped_sales = object.sales
                          .date_range(from, to)
                          .group_by(&:date)
                          .to_a
    ## First creates a nested array with the following structure:
    ## [
    ##  [DATE1, [SALE#1, SALE#2]],
    ##  [DATE2, [SALE#1, SALE#2]],
    ## ]
    grouped_sales.each_with_index do |date, index|
      day_after = date.first + 1.day
      if !grouped_sales[index + 1].nil? and grouped_sales[index + 1][0] != day_after
        ## Iterating through the array, if the day after each cycle is missing, it inserts a new empty day.
        grouped_sales.insert(index + 1, [day_after, []])
      end
      if formatted_time
        grouped_sales[index] = {date.first.strftime("%d/%m/%y") => date.second.inject(0){|result,sale| result += sale[:quantity]}}
      else
        grouped_sales[index] = {date.first => date.second.inject(0){|result,sale| result += sale[:quantity]}}
      end
    end
    ## Works like a fucking charm!
  end

    private

    def best_pairs_to_chart(pairs_number = 10)
      best_pairs = object.panoplies.sort_by(&:importance).last(pairs_number)
      best_pairs_to_chart = [
                            ["Prodotto", "Quantità",{ role: 'style' }]
                          ]
      most_sold = best_pairs.first[:quantity]
      best_pairs.each do |panoplie|
        sales_vs_best = panoplie[:quantity].fdiv(most_sold)
        intensity = (255 * sales_vs_best).round.to_s(16)
        best_pairs_to_chart << [panoplie.other_product(object)[:code], panoplie[:quantity], "#0000#{intensity}"]
      end
      best_pairs_to_chart
    end

    def values_for_pie_chart
      ticket_by_size.unshift(['Quantità nello scontrino', 'Ripetizioni'])
    end

    def values_for_scatterplot
      values_for_scatterplot = [["Data", "Vendite"]]
      complete_date_sales.map{|hash| values_for_scatterplot << hash.to_a.flatten}
      return values_for_scatterplot
    end

    def ticket_by_size
      counted_tickets = Hash.new(0)
      object.tickets.map{ |ticket| ticket.products.size }.each do |ticket|
        counted_tickets["#{ticket} quantità"] += 1
      end
      counted_tickets.to_a
    end

    def probable_sales(product)
      ## The predicted number of sales between two products A and B where Pa is the probability that a ticket
      ## contains product A and Pb is the same for product B.
      ## Since the probability that a ticket contains both A and B is Pa * Pb and Px is the ratio between
      ## tickets with product X and all tickets, the formula for measuring how many times A and B would be sold
      ## together if covariance == 0 is Pa * Pb * total_tickets.
      ## We can simplify and obtain the following formula.
      (object.tickets.uniq.size * product.tickets.uniq.size).fdiv(Ticket.all.size)
    end

end
