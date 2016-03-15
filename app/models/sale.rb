class Sale < ActiveRecord::Base

  belongs_to :product

  scope :new_sales, -> { where(checked: false) }

  def sales_file
  end

end
