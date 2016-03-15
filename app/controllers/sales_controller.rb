class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  require 'bigdecimal'

  def index
    @sales = Sale.all
    @lucky_one = @sales.pluck(:id).sample
  end

  def show
  end

  def new
    @sale = Sale.new
  end

  def edit
  end

  def create
    @sale = Sale.new(params_hash)
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_file
    file = params[:sales_file]
    parse(file)
    redirect_to sales_path
  end

  private
    def set_sale
      @sale = Sale.find(params[:id])
    end

    def parse(file)
      File.read(file.path).scrub.split("\n").each do |sale|
        check_for_regex(sale)
      end
    end

    def check_for_regex(line)
      regex = /(\d{2}\/\d{2}\/\d{2})\s+(\d{4,7})\s+(\d+,\d+)\s+(\d+)\s+\d+\/\d+\/(\d+)\/\d+(\/[MN].+)?/
      match = line.match regex
      if !match.nil? and match[6].nil? and match[2] != '73729'
        create_sale_and_product(match)
      end
    end

    def create_sale_and_product(match)
      result = {
                date: DateTime.strptime(match[1],'%d/%m/%y'),
                product_code: match[2],
                price:  BigDecimal(match[3].gsub(',','.')),
                quantity: match[4],
                transaction_code: match[5],
                checked: false,
              }
      Sale.find_or_create_by(result)
      if Product.find_by_code(match[2]).nil?
        Product.create({code: match[2]})
      end
    end
end
