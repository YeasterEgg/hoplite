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
    @logs = Dir.glob("#{Rails.root}/log/*").map{|file| file.split('/').last }
  end

  def log_to_ajax
    file_name = params[:file]
    file = File.read(Rails.root.join('log',file_name+'.log'))
    if file
      render text: file
    else
      redirect_to :root
    end
  end
end
