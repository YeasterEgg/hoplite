class Ticket < ActiveRecord::Base

  has_many :sales
  has_many :products, through: :sales

end
