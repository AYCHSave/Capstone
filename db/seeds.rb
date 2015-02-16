# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'
Faker::Config.locale = 'en-US'
# Generate the 2 basic roles
Role.create(role_id: 1, role_name: 'Administrator')
Role.create(role_id: 2, role_name: 'Customer')

# Generate 80 users (with "customer" role) (Admins created separately)
80.times do
	username = "#{Faker::Hacker.ingverb}#{Faker::Hacker.noun}#{rand(99)}"
	u = User.new
		# u.user_id = SecureRandom.random_number
		u.user_username = username
		u.user_password = SecureRandom.base64(12)
		u.roles_role_id = 2
	u.save
end

# Generate 80 customers
80.times do
	c = Customer.new
		firstname = "#{Faker::Name.first_name}"
		lastname = "#{Faker::Name.last_name}"
		# c.customer_id = SecureRandom.random_number
		c.cust_email = "#{Faker::Internet.free_email(firstname)}"
		c.cust_phone1 = "#{Faker::PhoneNumber.phone_number}"
		c.cust_phone2 = "#{Faker::PhoneNumber.cell_phone}"
		c.cust_title = "#{Faker::Name.prefix}"
		c.cust_firstname = firstname
		c.cust_lastname = lastname
		# c.users_user_id = ""
end

# Generate 100 accounts
100.times do
    a = Account.new
    	a.account_id =  SecureRandom.random_number(999999999999) 
    	a.account_balance = (200.0 - 5.0) * rand() + 5
    	a.date_opened = "#{Faker::Date.between(10.years.ago, Date.today)}"
    a.save
end

