class CreateDatabaseStructure < ActiveRecord::Migration
  def change
    create_table :database_structures do |t|
    end
  end

  def self.up
  		### --- BEGIN CREATE DB STRUCTURE --- ###
	  	create_table "account_types", primary_key: "acct_type_id", force: true do |t|
	    t.string  "acct_type_name",     limit: 14
	    t.decimal "acct_interest_rate",            precision: 4, scale: 3, default: 0.0, null: false
	  end

	  create_table "accounts", primary_key: "account_id", force: true do |t|
	    t.integer "customers_customer_id",                                         null: false
	    t.integer "account_types_acct_type_id", limit: 1,                          null: false
	    t.decimal "account_balance",                      precision: 10, scale: 2, null: false
	    t.date    "date_opened",                                                   null: false
	  end

	  add_index "accounts", ["account_types_acct_type_id"], name: "fk_accounts_account_types1_idx", using: :btree
	  add_index "accounts", ["customers_customer_id"], name: "fk_accounts_customers1_idx", using: :btree

	  create_table "addresses", primary_key: "customers_customer_id", force: true do |t|
	    t.string "cust_address1",      limit: 60, null: false
	    t.string "cust_address2",      limit: 60
	    t.string "zip_codes_zip_code", limit: 10, null: false
	  end

	  add_index "addresses", ["customers_customer_id"], name: "fk_addresses_customers1_idx", using: :btree
	  add_index "addresses", ["zip_codes_zip_code"], name: "fk_addresses_zip_codes1_idx", using: :btree

	  create_table "administrators", primary_key: "admin_id", force: true do |t|
	    t.string  "admin_firstname", limit: 40, null: false
	    t.string  "admin_lastname",  limit: 40, null: false
	    t.integer "users_user_id",              null: false
	  end

	  add_index "administrators", ["users_user_id"], name: "fk_administrators_users1_idx", using: :btree

	  create_table "customers", primary_key: "customer_id", force: true do |t|
	    t.string  "cust_email",     limit: 75
	    t.string  "cust_phone1",    limit: 20
	    t.string  "cust_phone2",    limit: 20
	    t.string  "cust_title",     limit: 4
	    t.string  "cust_firstname", limit: 40
	    t.string  "cust_lastname",  limit: 40
	    t.integer "users_user_id",             null: false
	  end

	  add_index "customers", ["cust_lastname", "cust_firstname"], name: "NAME_LAST_FIRST", using: :btree
	  add_index "customers", ["users_user_id"], name: "fk_customers_users1_idx", using: :btree

	  create_table "roles", primary_key: "role_id", force: true do |t|
	    t.string "role_name", limit: 45, null: false
	  end

	  add_index "roles", ["role_name"], name: "role_name_UNIQUE", unique: true, using: :btree

	  create_table "states", id: false, force: true do |t|
	    t.integer "id",                      null: false
	    t.string  "name",         limit: 50
	    t.string  "abbreviation", limit: 4
	    t.string  "assoc_press",  limit: 14
	  end

	  add_index "states", ["abbreviation"], name: "abbreviation", using: :btree
	  add_index "states", ["id"], name: "id", using: :btree
	  add_index "states", ["id"], name: "id_2", using: :btree
	  add_index "states", ["name"], name: "name", using: :btree

	  create_table "transaction_types", primary_key: "trans_type_id", force: true do |t|
	    t.string "trans_type_name", limit: 30
	  end

	  add_index "transaction_types", ["trans_type_name"], name: " BY_TRANS_TYPE_NAME", using: :btree

	  create_table "transactions", primary_key: "trans_id", force: true do |t|
	    t.integer  "accounts_account_id",             limit: 8,                            null: false
	    t.integer  "transaction_types_trans_type_id",                                      null: false
	    t.datetime "trans_date",                                                           null: false
	    t.text     "trans_description",               limit: 255
	    t.decimal  "trans_amount",                                precision: 10, scale: 2, null: false
	  end

	  add_index "transactions", ["accounts_account_id"], name: "fk_transactions_accounts1_idx", using: :btree
	  add_index "transactions", ["trans_date", "trans_id"], name: "BY_DATE", using: :btree
	  add_index "transactions", ["trans_date", "trans_id"], name: "BY_TYPE", using: :btree
	  add_index "transactions", ["transaction_types_trans_type_id"], name: "fk_transactions_transaction_types1_idx", using: :btree

	  create_table "users", primary_key: "user_id", force: true do |t|
	    t.string  "user_username", limit: 30, null: false
	    t.string  "user_password", limit: 30, null: false
	    t.integer "roles_role_id", limit: 1,  null: false
	  end

	  add_index "users", ["roles_role_id"], name: "fk_users_roles1_idx", using: :btree
	  add_index "users", ["user_username"], name: "user_username_UNIQUE", unique: true, using: :btree

	  create_table "zip_codes", primary_key: "zip_code", force: true do |t|
	    t.string  "city",            limit: 45, null: false
	    t.integer "states_state_id",            null: false
	  end

	  add_index "zip_codes", ["states_state_id"], name: "states_state_id", using: :btree
	  add_index "zip_codes", ["zip_code"], name: "zip_code", using: :btree
	  ### --- END CREATE DB STRUCTURE --- ###
  end

  def self.down

  end
end