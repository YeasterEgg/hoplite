class MatchMaker

  def initialize(date = Ticket.first[:date])
    Ticket.where("date >= :start_date", {start_date: date}).each do |ticket|
      cycle_panoplie(ticket.products.sort_by(&:id))
    end
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
                          product_id_1: first[:id],
                          product_id_2: product[:id]
                          )
        end
      end
      cycle_panoplie(products)
    end
end
