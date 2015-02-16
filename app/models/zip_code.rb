class ZipCode < ActiveRecord::Base
	has_one :state
	belongs_to :address
end
