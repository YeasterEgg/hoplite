class MatchMaker

  attr_reader :logger

  def initialize(date = Ticket.first[:date])
    @logger = Logger.new(Rails.root.join('log','match_maker.log'))
    logger.info{"Started parsing for Panoplies, from date: #{date.strftime('%d/%m/%y')}"}
    Ticket.where("date >= :start_date", {start_date: date}).each do |ticket|
      cycle_panoplie(ticket.products.sort_by(&:id))
    end
    logger.info{"What can I say? It was great, till next time!"}
  end

  private

    def cycle_panoplie(products)
      return if products.size == 1
      first = products.shift
      products.each do |product|
        next if product == first
        if panoplie = Panoplie.find_by_product_id_1_and_product_id_2(first[:id], product[:id])
          panoplie.increment!(:quantity, 1)
        else
          Panoplie.create(
                          quantity: 1,
                          product_id_1: first,
                          product_id_2: product
                          )
        end
      end
      cycle_panoplie(products)
    end
end
