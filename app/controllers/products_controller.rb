class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :graph_data]

  def index
    ahoy.track "Product Index"
    params[:q] ||= {}
    params[:page] ||= 1
    @search = Product.ransack(params[:q])
    @collection = @search.result
                         .order("total_sales DESC")
                         .page(params[:page])
                         .per_page(20)
                         .decorate
    if @collection.length > 10
      @lucky_one = @collection.sample[:id]
    else
      @lucky_one = '2eazy'
    end
  end

  def show
    ahoy.track "Product #{@product[:code]}"
    @search = Product.ransack(params[:q])
    if @product[:name].nil?
      ProductFinder.new(@product)
    end
    @hashed_pairs = @product.hashed_pairs
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
