class SalesController < ApplicationController

  require 'bigdecimal'

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
    redirect_to products_path
  end

  private

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
        Product.create({code: match[2], total_sales: 1})
      else
        Product.find_by_code(match[2]).increase!(:total_sales, match[4])
      end
    end
end
