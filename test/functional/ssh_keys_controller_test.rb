require 'test_helper'

class SshKeysControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create" do
  #   get :create
  #   assert_response :success
  # end

  test "should destroy" do
    @key = Factory(:ssh_key)
    post :destroy, :id => @key.id
    assert_response :redirect
  end

end
