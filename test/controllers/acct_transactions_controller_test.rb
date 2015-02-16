require 'test_helper'

class AcctTransactionsControllerTest < ActionController::TestCase
  setup do
    @acct_transaction = acct_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acct_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acct_transaction" do
    assert_difference('AcctTransaction.count') do
      post :create, acct_transaction: {  }
    end

    assert_redirected_to acct_transaction_path(assigns(:acct_transaction))
  end

  test "should show acct_transaction" do
    get :show, id: @acct_transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @acct_transaction
    assert_response :success
  end

  test "should update acct_transaction" do
    patch :update, id: @acct_transaction, acct_transaction: {  }
    assert_redirected_to acct_transaction_path(assigns(:acct_transaction))
  end

  test "should destroy acct_transaction" do
    assert_difference('AcctTransaction.count', -1) do
      delete :destroy, id: @acct_transaction
    end

    assert_redirected_to acct_transactions_path
  end
end
