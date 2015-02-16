json.array!(@acct_transactions) do |acct_transaction|
  json.extract! acct_transaction, :id
  json.url acct_transaction_url(acct_transaction, format: :json)
end
