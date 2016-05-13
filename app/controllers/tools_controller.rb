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
    @logs = Dir.glob(Rails.root.join('log','*')).map{|path| path.split('/').last}
  end

  def log_to_ajax
    file_name = params[:file]
    file = File.read(Rails.root.join('log',"#{file_name}.log"))
    if file
      render text: file
    else
      redirect_to :back
    end
  end

  def match_maker
    MatchMaker.new
    redirect_to :back
  end

  def product_finder
    ProductFinder.nightshift(10)
    redirect_to :back
  end

  def delete_log
    log = "#{params[:file]}.log"
    log_path = Rails.root.join('log',log)
    File.delete(log_path) if File.exist?(log_path)
    render inline: "location.reload();"
  end

  def show_data
    @sales_quantities = Ticket.all.group_by(&:quantity).sort.map{|key,value| [key, value.size] }
    @sale_dates = []
    @sale_prices = []
    @total_worth = Ticket.all.pluck(:total_worth).sum
    @total_quantity = Ticket.all.pluck(:quantity).sum
    @average_sale = @total_worth / @total_quantity
  end

end
