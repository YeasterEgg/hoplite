class PanoplieDecorator < ApplicationDecorator
  delegate_all

  ########
  ## Basic methods
  ########

  def update_coefficients
    importance = importance_calculator(correlation_factor, real_probable_factor)
    object.update_attributes({importance: importance})
  end

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
    (product_id_1[:price] + product_id_2[:price]) * quantity
  end

  ########
  ## Coefficient calculators - They ALL must be in the range [-1/0, 1] so that they can be easily combined.
  ########

  def correlation_factor
    ## Some kind of a Pearson Correlation Coefficient
    product_1_sales_date = product_id_1.decorate.complete_date_sales
    product_2_sales_date = product_id_2.decorate.complete_date_sales
    ## Created 2 arrays, each has one hash for each day when the product has been sold, with date => total_sales
    return 1
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
    factors = [correlation_factor, real_probable_factor, perfect_sales_factor, money_factor]
    factors.sum.fdiv(factors.size)
  end

  def importance_calculator_v2
    factors = [correlation_factor, real_probable_factor, perfect_sales_factor, money_factor]
    factors.inject(1){|result, factor| result *= factor}.to_f
  end

end
