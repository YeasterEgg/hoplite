class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
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
    if @product[:name].nil?
      @product.set_name
    end
    @all_pairs = @product.all_pairs
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params[:code])
    end

    def product_params
      params.require(:product).permit(:name, :code)
    end
end
