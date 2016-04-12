class Parser

  attr_reader :logger

  def initialize(file)
    @logger = Logger.new(Rails.root.join('log','prices_import.log'))
    ## Open a .txt file and extrapolate the data creating Products, Sales and Tickets
    logger.info{"Starting to read #{File.basename(file)}..."}
    IO.readlines(file.path).each_with_index do |sale, index|
      if index % 5000 == 0
        logger.info{"Reading line \##{index}"}
      end
      check_for_regex(sale.scrub)
    end
    logger.info{"Finished without errors, FuckYEAH!"}
  end

  private

    def check_for_regex(line)
      ## Regex specific for this kind of files, from each line creates a Sale object and creates/updates
      ## a Product and a Ticket object

      regex = /\A(\d{2}\/\d{2}\/\d{2})\s+(\d{4,7})\s+(\d+,\d+)\s+(\d+)\s+\d+\/\d+\/(\d+)\/\d+(\/[MN].+)?/
      match = line.match regex
      if !match.nil? and match[6].nil? and match[2] != '73729' and match[2] != '65977'
        create_sale_and_product(match)
      end
    end

    def create_sale_and_product(match, copy_control = false)

      ## This two variables will be used to check whether if the sale belongs to the same ticket as the
      ## last one, without storing useless informations forever.
      ## If it is the first cycle, it will use empty values, otherwise they will be set at the end
      ## of each cycle.

      price_to_decimal = match[3].gsub(',','.').to_f
      quantity = match[4].to_f
      date = DateTime.strptime(match[1],'%d/%m/%y')

      ## Some of regex results need to be saved after a little bit of work.

      new_sale_hash = {
                        price:  price_to_decimal,
                        quantity: quantity,
                      }

      ## Creates an hash that will contain all the values for new Sale.

      product = Product.find_by_code(match[2])
      if product.nil?
        product = Product.create({
                                  code: match[2],
                                  total_sales: quantity,
                                  price: price_to_decimal,
                                  })
      else
        product.update_attribute(:price, product.new_price_average(price_to_decimal))
        product.increment!(:total_sales, quantity.to_i)
      end

      new_sale_hash[:product_id] = product.id

      ## If a product with the code already exists it just updates it, otherwise new product.
      ## Then adds product_id to the new sale hash

      if ticket = Ticket.find_by_code_and_date(match[5], date)
        ticket.increment!(:quantity, quantity)
        ticket.increment!(:total_worth, price_to_decimal * quantity)
      else
        ticket = Ticket.create({
                                quantity: quantity,
                                total_worth: price_to_decimal * quantity,
                                date: date,
                                code: match[5],
                              })
      end

      new_sale_hash[:ticket_id] = ticket.id

      ## If a ticket with the same sale_date exists it increments its values, otherwise it will create
      ## a new ticket item. Then it appends ticket_id to the sale Hash

      Sale.create(new_sale_hash)

      ## Finally creates a new sale

    end
end
