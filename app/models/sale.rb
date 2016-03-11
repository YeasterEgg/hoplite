class Sale < ActiveRecord::Base

  belongs_to :product

  def sales_file
  end

end
