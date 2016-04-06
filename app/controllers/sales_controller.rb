class SalesController < ApplicationController

  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_file
    file = params[:sales_file]
    Parser.new(file)
    redirect_to products_path
  end

end
