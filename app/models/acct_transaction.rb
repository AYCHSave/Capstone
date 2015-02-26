class AcctTransaction < ActiveRecord::Base
	# self.primary_key = "id"
	
	belongs_to :account
	has_one :transaction_type
end
