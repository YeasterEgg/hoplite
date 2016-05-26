class MatchMaker

  attr_reader :logger
  LOGFILE = 'match_maker.log'

  ## The real deal: this class is the hearth of the webapp, it looks for couples of products sold togheter and
  ## creates the Panoplie object relative to those products.
  ## VERY IMPORTANT: When a Panoplie instance is created, the first product (product_id_1) will ALWAYS have the
  ## lowest ID between the two, to shorten research.

  def initialize( log = LOGFILE, tickets = Ticket.unread )
    @logger = File.new(Rails.root.join('public','log', log ), 'a')
    ## Creates the log file

    time_start = Time.now
    length = tickets.size
    ## This is just to keep track of how long it takes to analyze.

    logger.puts("Started parsing for Panoplies at: #{time_start.strftime('%H:%M')}")
    logger.puts("There are #{length} new tickets to check, it's going to be a long night...")
    ## Every time it runs, it will write 5 lines in the logger.

    tickets.each do |ticket|
      ## Only selects unread tickets.

      cycle_panoplie(ticket.products.uniq(&:id).sort_by(&:id), ticket)
      ## For each tickets selects every single product (uniq by id), then it sorts by ID.

      ticket.update_attribute(:read, true)
      ## If the call to the next methods goes well it will update the status of the ticket.

    end
    time_end = Time.now
    time_each_ticket = (time_end - time_start).fdiv(length)
    ## Again, just to keep track of the speed.

    logger.puts("Finally! It's #{time_end.strftime('%H:%M')} and it took me around #{time_each_ticket.round(4)} seconds each Ticket.")
    logger.puts("----    ----    ----    ----    ----    ----    ----    ----")
    logger.close
  end

  private

    def cycle_panoplie(products, ticket)
      return true if products.size == 1
      ## It's my first real recursive function, hope it works well!
      ## Being recursive, it will exit returning true if products size get to 0.

      first = products.shift
      ## The first product in products list is taken out of the array to be analyzed against each other.

      products.each do |product|
        solo_sales = ticket.products.where.not(id: [first[:id], product[:id]]).empty? ? 1 : 0
        ## If the products of the ticket are just those two, it's saved.

        if panoplie = Panoplie.find_by_product_id_1_and_product_id_2(first[:id], product[:id])
          panoplie.increment!(:quantity, 1)
          ## If a panoplie with this 2 products already exists it will be increased by 1.
          panoplie.increment!(:solo_sales, solo_sales)
          ## And if is a solo sale, it increments it too.

        else
          panoplie = Panoplie.create(
                                      quantity: 1,
                                      product_id_1: first,
                                      product_id_2: product,
                                      solo_sales: solo_sales,
                                    )
          ## Else, a new one will be created.
        end
        update_values(panoplie.decorate,'correlation_factor', 'real_probable_factor', 'money_factor', 'perfect_sales_factor')
        panoplie.update_attribute(:importance, panoplie.decorate.importance_calculator)
      end
      cycle_panoplie(products, ticket)
      ## Now products is one item shorter (hence the shift), the function being recursive will proceed one step
      ## further.
    end

    def update_values(decorated_panoplie = Panoplie.last.decorate, *values)
      values.each do |value|
        new_value = decorated_panoplie.send value
        decorated_panoplie.update_attribute(value, new_value)
      end
    end

end
