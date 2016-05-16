class Panoplie < ActiveRecord::Base

  belongs_to :product_id_1, class_name: "Product", foreign_key: "product_id_1"
  belongs_to :product_id_2, class_name: "Product", foreign_key: "product_id_2"

  def correlation_coefficient
    first_ticket_sales_by_date = product_id_1.sales
                                             .group_by{|sale| sale.ticket.date}
                                             .map{|date,sales| {date => sales.inject(0){|total, sale| total += sale.quantity}}}
    first_ticket_sales_by_date = product_id_2.sales
                                             .group_by{|sale| sale.ticket.date}
                                             .map{|date,sales| {date => sales.size}}
    ## Created 2 arrays, each has one hash for each day when the product has been sold, with date => total_sales
    return '0'
  end

end
