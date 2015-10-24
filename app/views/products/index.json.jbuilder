json.array!(@products) do |product|
  json.extract! product, :id, :category_id, :user_id, :title, :description, :stock, :price, :status
  json.url product_url(product, format: :json)
end
