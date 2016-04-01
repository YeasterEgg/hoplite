module ProductsHelper

  def nice_price(value)
    number_to_currency(value, unit: "€", separator: ",", delimiter: "", format: "%n %u")
  end

  def nice_percentual(value)
    "#{(100*value).round(2)}%"
  end

end
