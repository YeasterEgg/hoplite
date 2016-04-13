class ToolsController < ApplicationController

  def destroy_all
    Sale.destroy_all
    Product.destroy_all
    Ticket.destroy_all
    Visit.destroy_all
    Ahoy::Event.destroy_all
    Panoplie.destroy_all
    redirect_to products_path
  end

  def ahoy_mates
    @all_guests = Visit.all
  end

  def onan
    file = File.new(Rails.root.join('public', 'seed.txt'))
    date = Ticket.last[:date].at_midnight + 1.day
    Parser.new(file)
    date ||= Ticket.first[:date].at_midnight
    MatchMaker.new(ticket[:date])
    redirect_to products_path
  end

  def upload_file
    file = params[:sales_file]
    Parser.new(file)
    redirect_to products_path
  end

end
