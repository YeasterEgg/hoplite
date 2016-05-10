class ToolsController < ApplicationController

  def destroy_all
    Sale.destroy_all
    Product.destroy_all
    Ticket.destroy_all
    Panoplie.destroy_all
    redirect_to products_path
  end

  def upload_file
    file = params[:sales_file]
    Parser.new(file)
    redirect_to products_path
  end

  def show_logger
    @file = Rails.root.join('log','match_maker.log')
  end

end
