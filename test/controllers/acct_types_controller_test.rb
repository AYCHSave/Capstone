require 'test_helper'

class AcctTypesControllerTest < ActionController::TestCase
  setup do
    @acct_type = acct_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acct_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acct_type" do
    assert_difference('AcctType.count') do
      post :create, acct_type: {  }
    end

    assert_redirected_to acct_type_path(assigns(:acct_type))
  end

  test "should show acct_type" do
    get :show, id: @acct_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @acct_type
    assert_response :success
  end

  test "should update acct_type" do
    patch :update, id: @acct_type, acct_type: {  }
    assert_redirected_to acct_type_path(assigns(:acct_type))
  end

  test "should destroy acct_type" do
    assert_difference('AcctType.count', -1) do
      delete :destroy, id: @acct_type
    end

    assert_redirected_to acct_types_path
  end
end
