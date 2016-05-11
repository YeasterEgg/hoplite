class MatchMaker

  attr_reader :logger

  ## The real deal: this class is the hearth of the webapp, it looks for couples of products sold togheter and
  ## creates the Panoplie object relative to those products.
  ## VERY IMPORTANT: When a Panoplie instance is created, the first product (product_id_1) will ALWAYS have the
  ## lowest ID between the two, to shorten research.

  def initialize()
    @logger = Logger.new(Rails.root.join('log','match_maker.log'))
    ## Creates the log file

    time_start = Time.zone.now
    length = Ticket.unread.size
    ## This is just to keep track of how long it takes to analyze.

    logger.info{"Started parsing for Panoplies at: #{time_start.strftime('%d/%m/%y')}"}
    logger.info{"There are #{length} new tickets to check, it's going to be a long night..."}
    ## Every time it runs, it will write 5 lines in the logger.

    Ticket.unread.each do |ticket|
      ## Only selects unread tickets.

      cycle_panoplie(ticket.products.uniq(&:id).sort_by(&:id))
      ## For each tickets selects every single product (uniq by id), then it sorts by ID.

      ticket[:read] = true
      ## If the call to the next methods goes well it will update the status of the ticket.

    end
    time_end = Time.zone.now
    time_each_ticket = (time_end - time_start).fdiv(length)
    ## Again, just to keep track of the speed.

    logger.info{"Finally! It's #{time_end.strftime('%d/%m/%y')} and it took me around #{time_each_ticket} seconds each Ticket."}
    logger.info{"----    ----    ----    ----    ----    ----    ----    ----"}
  end

  private

    def cycle_panoplie(products)
      return true if products.size == 1
      ## It's my first real recursive function, hope it works well!
      ## Being recursive, it will exit returning true if products size get to 0.

      first = products.shift
      ## The first product in products list is taken out of the array to be analyzed against each other.

      products.each do |product|
        if panoplie = Panoplie.find_by_product_id_1_and_product_id_2(first[:id], product[:id])
          panoplie.increment!(:quantity, 1)
          ## If a panoplie with this 2 products already exists it will be increased by 1.

        else
          Panoplie.create(
                          quantity: 1,
                          product_id_1: first,
                          product_id_2: product
                          )
          ## Else, a new one will be created.

        end
      end
      cycle_panoplie(products)
      ## Now products is one item shorter (hence the shift), the function being recursive will proceed one step
      ## further.

    end
end
