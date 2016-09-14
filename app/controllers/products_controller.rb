class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :graph_data]

  def index
    params[:q] ||= {}
    params[:page] ||= 1
    @search = Product.ransack(params[:q])
    @collection = @search.result
                         .order("total_sales DESC")
                         .page(params[:page])
                         .per_page(10)
                         .decorate
  end

  def show
    @search = Product.ransack(params[:q])
    if @product[:name].nil?
      ProductFinder.new(@product)
    end
    @panoplies = @product.panoplies.sort_by(&:importance).last(20).reverse
  end

  def graph_data
    respond_to do |format|
      format.json {
        render :json => @product.values_for_charts
      }
    end
  end

  private
    def set_product
      @product = Product.find_by_code(params[:code]).decorate
    end

    def product_params
      params.require(:product).permit(:name, :code)
    end
end
