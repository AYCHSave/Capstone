class Customer < ActiveRecord::Base
	# self.primary_key = "id"
	
	belongs_to :user
	has_one :address
	has_many :accounts
end
