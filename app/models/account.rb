class Account < ActiveRecord::Base
	has_one :customer
	has_one :account_type
	has_many :transactions
end
