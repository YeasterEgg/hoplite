json.array!(@sales) do |sale|
  json.extract! sale, :id, :date, :number, :quantity
  json.url sale_url(sale, format: :json)
end
