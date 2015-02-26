# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker' #Using faker to seed make-believe data
require 'csv' #Pull data from local .csv files

# Seed zip_code and states tables via SQL import
# csv_text = File.read("#{Rails.root}/db/state_table.csv")
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   State.create!(row.to_hash)
# end

# csv_text = File.read("#{Rails.root}/db/zip_code_table.csv")
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   ZipCode.create!(row.to_hash)
# end

# Generate the 2 basic roles
# Role.create(id: 1, name: 'Administrator')
# Role.create(id: 2, name: 'Customer')

# Generate transaction types
TransactionType.create(id: 1, name: 'ATM')
TransactionType.create(id: 2, name: 'Check')
TransactionType.create(id: 3, name: 'Deposit')
TransactionType.create(id: 4, name: 'Auto-draft')
TransactionType.create(id: 5, name: 'POS')
TransactionType.create(id: 6, name: 'Transfer')
TransactionType.create(id: 7, name: 'Withdrawal')
TransactionType.create(id: 99, name: 'Miscellaneous')
# Generate account types
AcctType.create(id: 1, name: 'savings', interest_rate: 0.010)
AcctType.create(id: 2, name: 'checking', interest_rate: 0.000)

# Generate 100 users (with "customer" role) (Admins created separately)
users = [] # Empty array to store users
100.times do
	username = "#{Faker::Vehicle.make}#{Faker::BaconIpsum.word}-#{rand(999)}"
	u = User.new
		u.id = SecureRandom.random_number(9999999999)
		u.username = username.gsub(/\s+/,"")
		u.password = SecureRandom.base64(12)
		# u.role_id = 2
	u.save
	users << u # Put newly created user in the array
end

# Generate admin ("Administrator") user # ADMIN USER_ID IS 10 ZEROES
# User.create(id: 0000000000, username: 'admin', password: 'Pa55w0rd', role_id: 1)
User.create(id: 0000000000, username: 'admin', password: 'Pa55w0rd')

# Set up profile for above created admin user ADMIN_ID IS 10 ONES
Administrator.create(id: 1111111111, firstname: 'Peggy', lastname: 'Hill', user_id: 0000000000)

# Generate 100 customers
customers = [] # Empty array to store customers
100.times do |i|
	c = Customer.new
		user_id = User.select(:user_id).distinct

		firstname = nil
		lastname = Forgery('name').last_name
		name_prefix = nil

		case rand(1..11)
			when 1,2,3,4
				name_prefix = 'Mr.'
			when 5,6
				name_prefix = 'Dr.'
			when 7,8,9,10
				name_prefix = 'Ms.'
			when 11
				name_prefix = 'Mx.'
		end

		case (name_prefix)
			when 'Mr.'
				firstname = Forgery('name').male_first_name
			when 'Ms.'
				firstname = Forgery('name').female_first_name
			when 'Dr.', 'Mx.'
				firstname = Forgery('name').first_name	
		end

		c.user_id = users[i].id
		c.id = SecureRandom.random_number(999999999) # 9-digit integer
		c.email = "#{Faker::Internet.free_email(firstname)}"
		c.phone1 = "#{Faker::PhoneNumber.short_phone_number}"
		c.phone2 = "#{Faker::PhoneNumber.short_phone_number}"
		c.title = name_prefix
		c.firstname = firstname
		c.lastname = lastname
	c.save
	customers << c
end

# Generate 100 addresses for addresses table to be assigned to customers
100.times do |i|
	a = Address.new
		address1 = "#{Forgery::Address.street_address}"
		c = ZipCode.count
		zipcode = ZipCode.offset(rand(c)).first

		secondary_address = nil
		case rand(1..2)
			when 1 
				secondary_address = "#{Faker::Address.secondary_address}"
			when 2 
				secondary_address = nil
		end

		a.customer_id = customers[i].id
		a.address1 = address1
		a.address2 = secondary_address
		a.zip_code_zip_code = zipcode
	a.save
end

# Generate the first 100 accounts
accounts = []
100.times do |i|
    a = Account.new
    	a.customer_id = customers[i].id
    	a.acct_type_id = rand(1..2)
    	a.id =  SecureRandom.random_number(999999999999) # 12-digit account number
    	a.balance = (5000.0 - 5.0) * rand() + 5
    	a.date_opened = Time.at((Time.now.year - 10) + rand * (Time.now.to_f)).to_date
    a.save
    accounts << a
end

# Generate 50 more (secondary) accounts ("Some customers have more than 1 account")
50.times do |i|
    a = Account.new
    	a.customer_id = customers[i].id
    	a.acct_type_id = rand(1..2)
    	a.id =  SecureRandom.random_number(999999999999) 
    	a.balance = (200.0 - 5.0) * rand() + 5
    	a.date_opened = Time.at((Time.now.year - 10) + rand * (Time.now.to_f)).to_date
    a.save
end

# Generate historical transactions (AcctTransactions) for each account
descriptions_ATM = ['Bank Of Skyland ATM - Skyland, NC',
					'Citi Store ATM - Columbus, OH',
					'Jaspers Mini Mart ATM - Sweetwater, TX',
					'Cash Pints ATM - Black Mountain, NC',
					'TE Bank ATM - Charlotte, NC']
descriptions_Check = ['Check 1001',
					  'Check 1002',
					  'Check 1003',
					  'Check 1004',
				      'Check 1005']
descriptions_Deposit = ['Cash Deposit - ATM',
						'Check Deposit - ATM',
						'Check Image Deposit - Mobile',
						'Check Image Deposit - PC',
						'Credit/Debit Deposit',
						'Direct Payroll Deposit']			      				
descriptions_AutoDraft = ['Unified Healthcare - Premium Payment',
						  'Luke Energy Payment',
						  'North Taxolina Dept. of Revenue Payment',
						  'CodeUniversity',
						  'NetMovies',
						  'Nine Rivers Country Club - Membership Dues']
descriptions_POS = ['Jingles Markets POS Transaction',
					'EM-Bark Fuels POS Transaction',
					'Delk Department Stores POS Transaction',
					'Rudys Rib Shack POS Transaction',
					'Minas Muffler and Brake POS Transaction',
					'What-a-Burger POS Transaction',
					'Strickland Propane POS Transaction',
					'Mega Lo Mart POS Transaction']
descriptions_Transfer = 'Transfer'
descriptions_Withdrawal = 'Withdrawal'
descriptions_Miscellaneous = 'Miscellaneous'

atm_amounts = [20.00,40.00,60.00,80.00,100.00,120.00,140.00,160.00,180.00,200.00]
types = [1,2,3,4,5,6,7,99]
account_transactions = []

accounts.each do |i|
	80.times do |j|
		type = types.sample
			case (type)
				when 1
					description = descriptions_ATM.sample
					amount = atm_amounts.sample
				when 2
					description = descriptions_Check.sample
					amount = ((500.0 - 5.0) * rand() + 5) *-1
				when 3
					description = descriptions_Deposit.sample
					amount = (2000.0 - 5.0) * rand() + 5
				when 4
					description = descriptions_AutoDraft.sample
					amount = ((350.0 - 5.0) * rand() + 5) *-1
				when 5
					description = descriptions_POS.sample
					amount = ((150.0 - 5.0) * rand() + 5) *-1
				when 6
					description = descriptions_Transfer
					amount = (500.0 - 5.0) * rand() + 5
				when 7
					description = descriptions_Withdrawal
					amount = ((500.0 - 5.0) * rand() + 5) *-1
				when 99
					description = descriptions_Miscellaneous
					amount = ((500.0 - 5.0) * rand() + 5) *-1
			end

		t = AcctTransaction.new
			t.id = SecureRandom.random_number(99999999999999) # 14-digit BigInt
			t.account_id = accounts[j].id
			t.transaction_type_id = type
			t.date = Time.at((Time.now.month - 18) + rand * (Time.now.to_f)).to_date
			t.description = description
			t.amount = amount

		t.save
		account_transactions << t
	end
end