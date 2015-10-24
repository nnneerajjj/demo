json.array!(@offers) do |offer|
  json.extract! offer, :id, :product_id, :discount_percent, :start_time, :duration, :duration_type, :repeat, :end_time
  json.url offer_url(offer, format: :json)
end
