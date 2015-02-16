class Address < ActiveRecord::Base
	belongs_to :customer
	has_one :zip_code
	has_one :state, through: :zip_code
end
