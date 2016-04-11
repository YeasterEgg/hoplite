class SalesController < ApplicationController

  def upload_file
    file = params[:sales_file]
    Parser.new(file)
    redirect_to products_path
  end

end
