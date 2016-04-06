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
        check_for_regex(sale.scrub)
      end
    end

    def check_for_regex(line)
      regex = /\A(\d{2}\/\d{2}\/\d{2})\s+(\d{4,7})\s+(\d+,\d+)\s+(\d+)\s+\d+\/\d+\/(\d+)\/\d+(\/[MN].+)?/
      match = line.match regex
      if !match.nil? and match[6].nil? and match[2] != '73729' and match[2] != '65977'
        create_sale_and_product(match)
      end
    end

    def create_sale_and_product(match, copy_control = false)
      ## Creates a sale for each line of the file. Every sale group to a transaction, which can be
      ## identified via a date and transaction_code values. In order to combine them in a single
      ## parameter that is both univoque and decombined in its original values, i turn transaction_code
      ## into seconds and add them to date. Hoping that transaction_code never grows higher than
      ## 86400. Then maybe something like GMT or ms might come in handy.
      ## This also allows me to remove transaction_code as a column in database, since datetime kept
      ## track of hours, minutes and seconds even when I didn't need them.
      ## What a spiegone, buondio.
      ## EDIT 4/4/16: EVEN FUCKING WORSE
      ## Now when creating a new Sale object it also creates a new Ticket object: if last Sale has
      ## the same date value (i.e. is the same customer in the same ticket) it increases that ticket
      ## quantity and value by its own values, else it will create a new ticket.
      ## This makes the parsing of file slower but everything else will be faster i think.

      uniq_date_id = DateTime.strptime(match[1],'%d/%m/%y') + match[5].to_i.seconds
      price_to_decimal = match[3].gsub(',','.').to_f
      quantity = match[4].to_f

      ## Some of regex results need to be saved after a little bit of work.

      regex_results = {
                        date: uniq_date_id,
                        product_code: match[2],
                        price:  price_to_decimal,
                        quantity: quantity,
                        checked: false,
                      }

      new_sale = Sale.create(regex_results)

      ## Creates a new sale object with the hash from the regex.

      old_sale = Sale.last
      if old_sale && old_sale
        ticket.increment!(:quantity, quantity)
        ticket.increment!(:total_worth, price_to_decimal * quantity)
      else
        Ticket.create({
                        quantity: quantity,
                        total_worth: price_to_decimal * quantity,
                        sale_date: uniq_date_id
                      })
      end
      new_sale.update_attribute(:ticket_id, ticket.id )

      ## If a ticket with the same sale_date exists it increments its values, otherwise it will create
      ## a new ticket item.

      product = Product.find_by_code(match[2])
      if product.nil?
        Product.create({
                        code: match[2],
                        total_sales: quantity,
                        price: price_to_decimal,
                        name: nil,
                        })
      else
        product.update_attribute(:price, product.new_price_average(price_to_decimal))
        product.increment!(:total_sales, quantity.to_i)
      end

      ## If a product with the code already exists it just updates it, otherwise new product.

    end
end
