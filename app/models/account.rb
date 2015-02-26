class Account < ActiveRecord::Base
	# self.primary_key = "id"

	has_one :customer
	has_one :account_type
	has_many :acct_transactions
end
