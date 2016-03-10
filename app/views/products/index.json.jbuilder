json.array!(@products) do |product|
  json.extract! product, :id, :name, :code
  json.url product_url(product, format: :json)
end
