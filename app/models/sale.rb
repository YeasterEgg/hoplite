class Sale < ActiveRecord::Base

  has_many :products, through: :sold_product

  def sale_line
  end

end
