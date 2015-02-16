class Customer < ActiveRecord::Base
	belongs_to :user
	has_one :address
	has_many :accounts
end
