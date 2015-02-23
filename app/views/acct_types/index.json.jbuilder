json.array!(@acct_types) do |acct_type|
  json.extract! acct_type, :id
  json.url acct_type_url(acct_type, format: :json)
end
