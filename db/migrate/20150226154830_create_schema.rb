class CreateSchema < ActiveRecord::Migration
  def self.up
  # create ACCOUNTS table
  create_table "accounts", id: false, force: true do |t|
    t.integer "id",           limit: 8,                          null: false
    t.decimal "balance",                precision: 10, scale: 2, null: false
    t.date    "date_opened",                                     null: false
    t.integer "customer_id",  limit: 8,                          null: false
    t.integer "acct_type_id", limit: 1,                          null: false
  end
  execute "ALTER TABLE accounts ADD PRIMARY KEY (id);"
  add_index "accounts", ["acct_type_id"], name: "fk_accounts_acct_types1_idx", using: :btree
  add_index "accounts", ["customer_id"], name: "fk_accounts_customers1_idx", using: :btree

  # create ACCT_TRANSACTIONS table
  create_table "acct_transactions", id: false, force: true do |t|
    t.integer  "id",                  limit: 8,                            null: false
    t.datetime "date",                                                     null: false
    t.text     "description",         limit: 255
    t.decimal  "amount",                          precision: 10, scale: 2, null: false
    t.integer  "account_id",          limit: 8,                            null: false
    t.integer  "transaction_type_id",                                      null: false
  end
  execute "ALTER TABLE acct_transactions ADD PRIMARY KEY (id);"
  add_index "acct_transactions", ["account_id"], name: "fk_acct_transactions_accounts1_idx", using: :btree
  add_index "acct_transactions", ["date", "id"], name: "BY_DATE", using: :btree
  add_index "acct_transactions", ["transaction_type_id"], name: "fk_acct_transactions_transaction_types1_idx", using: :btree

  # create ACCT_TYPES table
  create_table "acct_types", force: true do |t|
    t.string  "name",          limit: 14
    t.decimal "interest_rate",            precision: 3, scale: 3, default: 0.0, null: false
  end

  # create ADDRESSES table
  create_table "addresses", id: false, force: true do |t|
    t.integer "customer_id",       limit: 8,  null: false
    t.string  "address1",          limit: 60, null: false
    t.string  "address2",          limit: 60
    t.string  "zip_code_zip_code", limit: 5,  null: false    
  end
  execute "ALTER TABLE addresses ADD PRIMARY KEY (customer_id);"
  add_index "addresses", ["zip_code_zip_code"], name: "fk_addresses_zip_codes1_idx", using: :btree

  # create ADMINISTRATORS table
  create_table "administrators", id: false, force: true do |t|
    t.integer "id",        limit: 8,  null: false
    t.string  "firstname", limit: 40, null: false
    t.string  "lastname",  limit: 40, null: false
    t.integer "user_id",   limit: 8,  null: false
  end
  execute "ALTER TABLE administrators ADD PRIMARY KEY (id);"
  add_index "administrators", ["lastname", "firstname", "id"], name: "BY_LASTNAME", using: :btree
  add_index "administrators", ["user_id"], name: "fk_administrators_users_idx", using: :btree

  # create CUSTOMERS table
  create_table "customers", id: false, force: true do |t|
    t.integer "id",        limit: 8,  null: false
    t.string  "email",     limit: 75
    t.string  "phone1",    limit: 20
    t.string  "phone2",    limit: 20
    t.string  "title",     limit: 11
    t.string  "firstname", limit: 40
    t.string  "lastname",  limit: 40
    t.integer "user_id",   limit: 8,  null: false
  end
  execute "ALTER TABLE customers ADD PRIMARY KEY (id);"
  add_index "customers", ["lastname", "firstname"], name: "NAME_LAST_FIRST", using: :btree
  add_index "customers", ["user_id"], name: "fk_customers_users1_idx", using: :btree

  # create STATES table
  create_table "states", force: true do |t|
    t.string "name",         limit: 30, null: false
    t.string "abbreviation", limit: 5,  null: false
    t.string "assoc_press",  limit: 14, null: false
  end
  add_index "states", ["name", "id"], name: "BY_NAME", using: :btree

  # create TRANSACTION_TYPES table
  create_table "transaction_types", id: false, force: true do |t|
  	t.integer "id", null: false
    t.string "name", limit: 30
  end
  execute "ALTER TABLE transaction_types ADD PRIMARY KEY (id);"
  
  # create USERS table
  create_table "users", id: false, force: true do |t|
    t.integer "id",       limit: 8,  null: false
    t.string  "username", limit: 30, null: false
    t.string  "password", limit: 30, null: false   
  end
  execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  add_index "users", ["username", "id"], name: "BY_USERNAME", using: :btree

  # create ZIP_CODES table
  create_table "zip_codes", id: false, force: true do |t|
    t.string  "zip_code", limit: 5,  null: false
    t.string  "city",     limit: 45, null: false
    t.string "state_abbreviation", limit: 3, null: false
  end
  execute "ALTER TABLE zip_codes ADD PRIMARY KEY (zip_code);"
  add_index "zip_codes", ["state_abbreviation"], name: "fk_zip_codes_states1_idx", using: :btree
  
  end

  def self.down
  end
end
