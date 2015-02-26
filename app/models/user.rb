class User < ActiveRecord::Base
	# self.primary_key = "id"

	# has_one :role
	has_many :customers
	has_many :administrators
end
