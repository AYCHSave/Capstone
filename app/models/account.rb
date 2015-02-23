class Account < ActiveRecord::Base
	has_one :customer
	has_one :account_type
	has_many :acct_transactions
end
