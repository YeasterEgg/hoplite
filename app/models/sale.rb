class Sale < ActiveRecord::Base

  belongs_to :product
  belongs_to :ticket

  scope :date_range, lambda { |from = Sale.first[:date], to = Sale.last[:date]| where('date >= ? AND date <= ?', from, to) }

  def date
    ticket[:date]
  end

end
