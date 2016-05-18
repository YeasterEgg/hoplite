class Sale < ActiveRecord::Base

  belongs_to :product
  belongs_to :ticket

  def date
    ticket[:date]
  end

end
