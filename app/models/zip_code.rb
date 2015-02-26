class ZipCode < ActiveRecord::Base
	# self.primary_key = "zip_code"
	
	has_one :state
	belongs_to :address
end
