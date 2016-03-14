class Sale < ActiveRecord::Base

  belongs_to :product

  scope :new_sales, -> { where(checked: false) }

  def sales_file
  end

  def set_as_old
    self.checked = true
    self.save
  end

end
