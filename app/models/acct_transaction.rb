class AcctTransaction < ActiveRecord::Base
	belongs_to :account
	has_one :transaction_type
end
