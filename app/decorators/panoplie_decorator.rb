class PanoplieDecorator < ApplicationDecorator
  delegate_all

  ########
  ## Basic methods
  ########

  def probable_sales(tickets = Ticket.all)
    ## The predicted number of sales between two products A and B where Pa is the expected value for a ticket
    ## to contain product A and Pb is the same for product B.
    ## Since the expected value for a ticket to contain both A and B is Pa * Pb and Px is the ratio between
    ## tickets with product X and all tickets, the formula for measuring how many times A and B would be sold
    ## together if covariance == 0 is Pa * Pb * total_tickets.
    ## We can simplify and obtain the following formula.
    (product_id_1.tickets.uniq.size * product_id_2.tickets.uniq.size).fdiv(tickets.size)
  end

  def total_worth
    (product_id_1[:price] + product_id_2[:price]) * object[:quantity]
  end

  ########
  ## Coefficient calculators - They ALL must be in the range [-1/0, 1] so that they can be easily combined.
  ########

  def correlation_factor(product1 = product_id_1, product2 = product_id_2, minimum_set_at_0 = false)
    ## Some kind of a Pearson Correlation Coefficient
    first_day = [product1.sales.first[:date], product2.sales.first[:date]].max
    last_day = [product1.sales.last[:date], product2.sales.last[:date]].min
    ## Sets the date range in common between the two products, it should be important for their sales data
    product1_sales = product1.decorate.complete_date_sales(first_day, last_day)
    product2_sales = product2.decorate.complete_date_sales(first_day, last_day)
    ## Created 2 arrays, each has one hash for each day when the product has been sold, with date => total_sales
    corr_fact = ArrayStatistic.pearson_correlation(product1_sales.map(&:values).flatten, product2_sales.map(&:values).flatten)
    if minimum_set_at_0
      corr_fact >= 0 ? corr_fact : 0
    else
      corr_fact
    end
  end

  def perfect_sales_factor
    total_tickets = product_id_1.tickets.uniq.size + product_id_2.tickets.uniq.size
    object[:solo_sales].fdiv(total_tickets/2)
  end

  def real_probable_factor
    ## How many more times a panoplie happens then its expected value, divided by the number of sales to normalize
    ## it, even if its value can never reach 1, it can get as close as possible to it.
    (object[:quantity] - probable_sales).fdiv(object[:quantity])
  end

  def money_factor
    total_worth.fdiv(product_id_1.total_worth + product_id_2.total_worth)
  end

  def importance_calculator
    object.factors.sum.fdiv(object.factors.size)
  end

  def importance_calculator_v2
    object.factors.inject(1){|result, factor| result *= factor}.to_f
  end

end
