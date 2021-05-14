require 'test_helper'

class Admin::MatchingControllerTest < ActionDispatch::IntegrationTest
  test "should be password protected" do
    get admin_matching_path
    assert_response :unauthorized
  end
end
