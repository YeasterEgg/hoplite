module ProductsHelper

  def nice_price(value)
    number_to_currency(value, unit: "€", separator: ",", delimiter: "", format: "%n %u")
  end

end
