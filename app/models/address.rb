class Address < ActiveRecord::Base
	# self.primary_key = "customer_id"
	
	belongs_to :customer
	has_one :zip_code
	has_one :state, through: :zip_code
end
