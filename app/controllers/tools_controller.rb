class ToolsController < ApplicationController

  def destroy_all
    Sale.destroy_all
    Product.destroy_all
    Ticket.destroy_all
    Visit.destroy_all
    Ahoy::Event.destroy_all
    redirect_to products_path
  end

  def ahoy_mates
    @all_guests = Visit.all
  end

  def onan
    file = File.new(Rails.root.join('public', 'seed.txt'))
    Parser.new(file)
    redirect_to products_path
  end

end
