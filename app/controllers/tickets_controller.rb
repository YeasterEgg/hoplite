class TicketsController < ApplicationController

  def show_data
    @sales_quantities = Ticket.all.group_by(&:quantity).sort.map{|key,value| [key, value.size] }
    @sale_dates = []
    @sale_prices = []
    @total_worth = Ticket.all.pluck(:total_worth).sum
    @total_quantity = Ticket.all.pluck(:quantity).sum
    @average_sale = @total_worth / @total_quantity
  end

end
