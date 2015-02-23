class CreateSchema < ActiveRecord::Migration
  def change
    # encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "accounts", primary_key: "account_id", force: true do |t|
    t.integer "customers_customer_id",                                      null: false
    t.integer "acct_types_acct_type_id", limit: 1,                          null: false
    t.decimal "account_balance",                   precision: 10, scale: 2, null: false
    t.date    "date_opened",                                                null: false
  end

  add_index "accounts", ["acct_types_acct_type_id"], name: "fk_accounts_acct_types1_idx", using: :btree
  add_index "accounts", ["customers_customer_id"], name: "fk_accounts_customers1_idx", using: :btree

  create_table "acct_transactions", primary_key: "trans_id", force: true do |t|
    t.integer  "accounts_account_id",             limit: 8,                            null: false
    t.integer  "transaction_types_trans_type_id",                                      null: false
    t.datetime "trans_date",                                                           null: false
    t.text     "trans_description",               limit: 255
    t.decimal  "trans_amount",                                precision: 10, scale: 2, null: false
  end

  add_index "acct_transactions", ["accounts_account_id"], name: "fk_acct_transactions_accounts1_idx", using: :btree
  add_index "acct_transactions", ["trans_date", "trans_id"], name: "BY_DATE", using: :btree
  add_index "acct_transactions", ["trans_date", "trans_id"], name: "BY_TYPE", using: :btree
  add_index "acct_transactions", ["transaction_types_trans_type_id"], name: "fk_acct_transactions_transaction_types1_idx", using: :btree

  create_table "acct_types", primary_key: "acct_type_id", force: true do |t|
    t.string  "acct_type_name",     limit: 14
    t.decimal "acct_interest_rate",            precision: 4, scale: 3, default: 0.0, null: false
  end

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
    t.string  "cust_title",     limit: 20
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

  create_table "states", force: true do |t|
    t.string "name",         limit: 15, null: false
    t.string "abbreviation", limit: 3,  null: false
    t.string "assoc_press",  limit: 8,  null: false
  end

  add_index "states", ["abbreviation", "name", "id"], name: "BY_ABBR_2", using: :btree
  add_index "states", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "states", ["name", "id"], name: "BY_NAME", using: :btree

  create_table "transaction_types", primary_key: "trans_type_id", force: true do |t|
    t.string "trans_type_name", limit: 30
  end

  add_index "transaction_types", ["trans_type_name"], name: " BY_TRANS_TYPE_NAME", using: :btree

  create_table "users", primary_key: "user_id", force: true do |t|
    t.string  "user_username", limit: 30, null: false
    t.string  "user_password", limit: 30, null: false
    t.integer "roles_role_id", limit: 1,  null: false
  end

  add_index "users", ["roles_role_id"], name: "fk_users_roles1_idx", using: :btree
  add_index "users", ["user_id"], name: "user_id", unique: true, using: :btree
  add_index "users", ["user_username"], name: "user_username_UNIQUE", unique: true, using: :btree

  create_table "zip_codes", primary_key: "zip_code", force: true do |t|
    t.string "city",                limit: 45, null: false
    t.string "states_abbreviation", limit: 3,  null: false
  end

  add_index "zip_codes", ["states_abbreviation"], name: "fk_zip_codes_states1_idx", using: :btree
  add_index "zip_codes", ["zip_code"], name: "zip_code", unique: true, using: :btree

  add_foreign_key "accounts", "acct_types", name: "fk_accounts_account_types1", column: "acct_types_acct_type_id", primary_key: "acct_type_id", dependent: :delete, options: "ON UPDATE CASCADE"
  add_foreign_key "accounts", "customers", name: "fk_accounts_customers1", column: "customers_customer_id", primary_key: "customer_id", dependent: :delete, options: "ON UPDATE CASCADE"

  add_foreign_key "acct_transactions", "accounts", name: "fk_transactions_accounts1", column: "accounts_account_id", primary_key: "account_id", dependent: :delete, options: "ON UPDATE CASCADE"
  add_foreign_key "acct_transactions", "transaction_types", name: "fk_transactions_transaction_types1", column: "transaction_types_trans_type_id", primary_key: "trans_type_id", dependent: :delete, options: "ON UPDATE CASCADE"

  add_foreign_key "addresses", "customers", name: "fk_addresses_customers1", column: "customers_customer_id", primary_key: "customer_id", dependent: :delete, options: "ON UPDATE CASCADE"
  add_foreign_key "addresses", "zip_codes", name: "fk_addresses_zip_codes1", column: "zip_codes_zip_code", primary_key: "zip_code", dependent: :delete, options: "ON UPDATE CASCADE"

  add_foreign_key "administrators", "users", name: "fk_administrators_users1", column: "users_user_id", primary_key: "user_id", dependent: :delete, options: "ON UPDATE CASCADE"

  add_foreign_key "customers", "users", name: "customers_users_user_id_fk", column: "users_user_id", primary_key: "user_id"
  add_foreign_key "customers", "users", name: "fk_customers_users1", column: "users_user_id", primary_key: "user_id", dependent: :delete, options: "ON UPDATE CASCADE"

  add_foreign_key "users", "roles", name: "fk_users_roles1", column: "roles_role_id", primary_key: "role_id", dependent: :delete, options: "ON UPDATE CASCADE"
  add_foreign_key "users", "roles", name: "users_roles_role_id_fk", column: "roles_role_id", primary_key: "role_id"

  add_foreign_key "zip_codes", "states", name: "fk_zip_codes_states1", column: "states_abbreviation", primary_key: "abbreviation", dependent: :delete, options: "ON UPDATE CASCADE"

end


    end
  end
end
