class Product < ActiveRecord::Base

  has_many :sales, through: :sold_product

end
