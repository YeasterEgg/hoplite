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
    parse(file)
    redirect_to products_path
  end

  private

    def parse(file)
      IO.readlines(file.path).each do |sale|
        check_for_regex(sale)
      end
    end

    def check_for_regex(line)
      regex = /\A(\d{2}\/\d{2}\/\d{2})\s+(\d{4,7})\s+(\d+,\d+)\s+(\d+)\s+\d+\/\d+\/(\d+)\/\d+(\/[MN].+)?/
      match = line.match regex
      if !match.nil? and match[6].nil? and match[2] != '73729' and match[2] != '65977'
        create_sale_and_product(match)
      end
    end

    def create_sale_and_product(match, skip_name = true)
      ## Creates a sale for each line of the file. Every sale group to a transaction, which can be
      ## identified via g date and transaction_code values. In order to combine them in a single
      ## parameter that is both univoque and decombined in its original values, i turn transaction_code
      ## into seconds and add them to date. Hoping that transaction_code never grows higher than
      ## 86400. Then maybe something like GMT or ms might come in handy.
      ## This also allows me to remove transaction_code as a column in database, since datetime kept
      ## track of hours, minutes and seconds even when I didn't need them.
      ## What a spiegone, buondio.
      result = {
                date: DateTime.strptime(match[1],'%d/%m/%y') + match[5].to_i.seconds,
                product_code: match[2],
                price:  match[3].gsub(',','.').to_f,
                quantity: match[4],
                checked: false,
              }
      Sale.find_or_create_by(result)
      product = Product.find_by_code(match[2])
      if product.nil?
        new_product = Product.create({
                                      code: match[2],
                                      total_sales: match[4],
                                      price: match[3].gsub(',','.').to_f,
                                      name: nil,
                                      })
      else
        product.update_attribute(:price, product.new_price_average(match[3].gsub(',','.').to_f))
        product.increment!(:total_sales, match[4].to_i)
      end
    end
end
