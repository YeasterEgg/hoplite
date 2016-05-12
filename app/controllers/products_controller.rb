class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :graph_data]

  def index
    @background = Dir.glob(Rails.root.join('app','assets','images','rndm','*')).map{|path| path.split('/').last}.sample
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
    @search = Product.ransack(params[:q])
    if @product[:name].nil?
      ProductFinder.new(@product)
    end
    @hashed_pairs = @product.hashed_pairs.first(20)
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
