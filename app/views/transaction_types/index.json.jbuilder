json.array!(@transaction_types) do |transaction_type|
  json.extract! transaction_type, :id
  json.url transaction_type_url(transaction_type, format: :json)
end
