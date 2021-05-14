require 'test_helper'

class SharesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @show = shows(:one)
    @story = stories(:one)
    @user = users(:one)
  end

  test "can increment share count for shows while logged in" do
    assert_difference('Share.count', 1) do
      post shares_url(show_id: @show.id), as: :json, headers: auth_header(@user)
    end
  end

  test "can increment share count for shows while logged out" do
    assert_difference('Share.count', 1) do
      post shares_url(show_id: @show.id), as: :json
    end
  end

  test "can increment share count for stories while logged in" do
    assert_difference('Share.count', 1) do
      post shares_url(story_id: @story.id), as: :json, headers: auth_header(@user)
    end
  end

  test "can increment share count for stories while logged out" do
    assert_difference('Share.count', 1) do
      post shares_url(story_id: @story.id), as: :json
    end
  end
end
