# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker' #Using faker to seed make-believe data
# zip_code and states tables not seeded here, done via SQL import

# Generate the 2 basic roles
Role.create(role_id: 1, role_name: 'Administrator')
Role.create(role_id: 2, role_name: 'Customer')
# Generate transaction types
TransactionType.create(trans_type_id: 1, trans_type_name: 'ATM')
TransactionType.create(trans_type_id: 2, trans_type_name: 'Check')
TransactionType.create(trans_type_id: 3, trans_type_name: 'Deposit')
TransactionType.create(trans_type_id: 4, trans_type_name: 'Auto-draft')
TransactionType.create(trans_type_id: 5, trans_type_name: 'POS')
TransactionType.create(trans_type_id: 6, trans_type_name: 'Transfer')
TransactionType.create(trans_type_id: 7, trans_type_name: 'Withdrawal')
TransactionType.create(trans_type_id: 99, trans_type_name: 'Miscellaneous')
# Generate account types
AcctType.create(acct_type_id: 1, acct_type_name: 'savings', acct_interest_rate: 0.010)
AcctType.create(acct_type_id: 2, acct_type_name: 'checking', acct_interest_rate: 0.000)

# Generate 100 users (with "customer" role) (Admins created separately)
users = [] # Empty array to store users
100.times do
	username = "#{Faker::Vehicle.make}#{Faker::BaconIpsum.word}-#{rand(999)}"
	u = User.new
		u.user_id = SecureRandom.random_number(999999999)
		u.user_username = username.gsub(/\s+/,"")
		u.user_password = SecureRandom.base64(12)
		u.roles_role_id = 2
	u.save
	users << u # Put newly created user in the array
end

# Generate admin ("Administrator") user # ADMIN USER_ID IS 10 ZEROES
User.create(user_id: 0000000000, user_username: 'admin', user_password: 'Pa55w0rd', roles_role_id: 1)

# Set up profile for above created admin user ADMIN USER_ID IS 10 NINES
Administrator.create(admin_id: 9999999999, admin_firstname: 'Peggy', admin_lastname: 'Hill', users_user_id: 0000000000)

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

		c.users_user_id = users[i].user_id
		c.customer_id = SecureRandom.random_number(999999999) # 9-digit integer
		c.cust_email = "#{Faker::Internet.free_email(firstname)}"
		c.cust_phone1 = "#{Faker::PhoneNumber.short_phone_number}"
		c.cust_phone2 = "#{Faker::PhoneNumber.short_phone_number}"
		c.cust_title = name_prefix
		c.cust_firstname = firstname
		c.cust_lastname = lastname
	c.save
	customers << c
end

# Generate 100 addresses for addresses table to be assigned to customers
100.times do |i|
	a = Address.new
		address1 = "#{Faker::Address.street_address}"
		c = ZipCode.count
		zipcode = ZipCode.offset(rand(c)).first

		secondary_address = nil
		case rand(1..2)
			when 1 
				secondary_address = "#{Faker::Address.secondary_address}"
			when 2 
				secondary_address = nil
		end

		a.customers_customer_id = customers[i].customer_id
		a.cust_address1 = address1
		a.cust_address2 = secondary_address
		a.zip_codes_zip_code = zipcode
	a.save
end

# Generate the first 100 accounts
accounts = []
100.times do |i|
    a = Account.new
    	a.customers_customer_id = customers[i].customer_id
    	a.acct_types_acct_type_id = rand(1..2)
    	a.account_id =  SecureRandom.random_number(999999999999) 
    	a.account_balance = (5000.0 - 5.0) * rand() + 5
    	a.date_opened = Time.at((Time.now.year - 10) + rand * (Time.now.to_f)).to_date
    a.save
    accounts << a
end

# Generate 50 more (secondary) accounts ("Some customers have more than 1 account")
50.times do |i|
    a = Account.new
    	a.customers_customer_id = customers[i].customer_id
    	a.acct_types_acct_type_id = rand(1..2)
    	a.account_id =  SecureRandom.random_number(999999999999) 
    	a.account_balance = (200.0 - 5.0) * rand() + 5
    	a.date_opened = Time.at((Time.now.year - 10) + rand * (Time.now.to_f)).to_date
    a.save
end

# Generate historical transactions (AcctTransactions) for each account

### TODOS!!!! ###
# => Limit date of transaction to be since account was created.
# => Fix "0.00" amount problem of certain transaction types.
# => For that matter, don't let ANY transactions be "0.00"
# => CREATE ROLLING BALANCE VARIABLE THAT UPDATES (array? hash?) WITH EA. NEW TRANSACTION
# => Pass the above "rolling balance" to Account object to use for its account balance value
# => Add more items to the descriptions arrays
#
### END TODOS ###
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
			t.trans_id = SecureRandom.random_number(99999999999999) # 14-digit BigInt
			t.accounts_account_id = accounts[j].account_id
			t.transaction_types_trans_type_id = type
			t.trans_date = Time.at((Time.now.month - 18) + rand * (Time.now.to_f)).to_date
			t.trans_description = description
			t.trans_amount = amount

		t.save
		account_transactions << t
	end
end