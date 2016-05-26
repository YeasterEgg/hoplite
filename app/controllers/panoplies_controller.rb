class PanopliesController < ApplicationController

  def show
    product_codes = params[:couple].split('_')
    product_ids = product_codes.map{|code| Product.find_by_code(code)[:id]}
    @panoplie = Panoplie.find_by_product_id_1_and_product_id_2(product_ids.first, product_ids.second)
    @panoplie_attributes = [
                            :correlation_factor,
                            :perfect_sales_factor,
                            :real_probable_factor,
                            :money_factor,
                            :quantity,
                            :importance
                          ]
  end
end
