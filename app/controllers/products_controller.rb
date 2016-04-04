class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :destroy]

  def index
    ahoy.track "Product Index"
    params[:q] ||= {}
    params[:page] ||= 1
    @search = Product.ransack(params[:q])
    @collection = @search.result.order("total_sales DESC").page(params[:page]).per_page(20)
    if @collection.length > 10
      @lucky_one = @collection.pluck(:id).sample
    else
      @lucky_one = '2eazy'
    end
  end

  def show
    ahoy.track "Product #{@product[:code]}"
    @search = Product.ransack(params[:q])
    if @product[:name].nil?
      @product.set_name_and_website
    end
    @all_pairs = @product.all_pairs
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def graph_data
    respond_to do |format|
      format.json {
        render :json => Product.find(params[:code]).values_for_charts
      }
    end
  end

  private
    def set_product
      @product = Product.find_by_code(params[:code])
    end

    def product_params
      params.require(:product).permit(:name, :code)
    end
end
