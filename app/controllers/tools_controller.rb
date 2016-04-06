class ToolsController < ApplicationController

  def destroy_all
    Sale.destroy_all
    Product.destroy_all
    Ticket.destroy_all
    redirect_to products_path
  end

  def ahoy_mates
    @all_guests = Visit.all
  end

end
