class Sale < ActiveRecord::Base

  belongs_to :product
  belongs_to :ticket

  scope :new_sales, -> { where(checked: false) }

end
