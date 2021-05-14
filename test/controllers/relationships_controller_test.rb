require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get relationships_url, as: :json, headers: auth_header(@user)
    assert_response :success
  end

  test "should get create" do
    # get relationships_create_url
    # assert_response :success
  end

  test "should get destroy" do
    # get relationships_destroy_url
    # assert_response :success
  end

end
