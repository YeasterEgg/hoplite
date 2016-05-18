class Panoplie < ActiveRecord::Base

  belongs_to :product_id_1, class_name: "Product", foreign_key: "product_id_1"
  belongs_to :product_id_2, class_name: "Product", foreign_key: "product_id_2"

  def to_param
    product_1 = Product.find(product_id_1)
    product_2 = Product.find(product_id_2)
    "#{product_1[:code]}_#{product_2[:code]}"
  end

  def other_product(product)
    if product == product_id_1
      product_id_2
    elsif product == product_id_2
      product_id_1
    else
      return false
    end
  end

end
