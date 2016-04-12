class Panoplie < ActiveRecord::Base

  belongs_to :product_id_1, class_name: "Product", foreign_key: "product_id_1"
  belongs_to :product_id_2, class_name: "Product", foreign_key: "product_id_2"

end
