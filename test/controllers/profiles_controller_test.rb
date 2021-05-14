require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @like = likes(:one)
    @relationship = relationships(:one)
    @relationship2 = relationships(:two)
  end

  test "should get current user" do
    get profile_url, as: :json, headers: auth_header(@user)

    assert_response :success

    assert_equal %w(username image reactions_count favorites_count followers_count following_count), response.parsed_body.keys
  end

  test "should get reactions" do
    get reactions_profile_url, as: :json, headers: auth_header(@user)

    assert_response :success
    assert_pagination

    assert_equal %w(id text hashtag user_id created_at updated_at show_id images likes_count sub_comments_count videos shares_count story_id tmsId), response.parsed_body['results'].first.keys
  end

  test "should get favorites" do
    get favorites_profile_url, as: :json, headers: auth_header(@user)

    assert_response :success
    assert_pagination

    assert_equal %w(id tmsId title seasonNum episodeNum shares_count likes_count comments_count stories_count activity_count popularity_score shortDescription seriesId rootId preferred_image_uri episodeTitle), response.parsed_body['results'].first.keys
  end

  test "should get followers" do
    get followers_profile_url, as: :json, headers: auth_header(@user)

    assert_response :success
    assert_pagination

    assert_equal %w(id username image bio), response.parsed_body['results'].first.keys
  end

  test "should get following" do
    get following_profile_url, as: :json, headers: auth_header(@user)

    assert_response :success
    assert_pagination

    assert_equal %w(id username image bio), response.parsed_body['results'].first.keys
  end
end
