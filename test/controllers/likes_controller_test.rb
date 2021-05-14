require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @like = likes(:one)
    @user = @like.user
    @series_id = '185044'
    @tms_id = 'SH006883590000'
    @show = Show.create(seriesId: @series_id, tmsId: @tms_id)
  end

  test "should get index" do
    get likes_url, as: :json, headers: auth_header(@user)
    assert_response :success
  end

  test "should create like" do
    params = {
      tmsId: @tms_id,
      seriesId: @series_id,
      liked: true
    }

    assert_difference('Like.count', 1) do
      post likes_url, params: params, as: :json, headers: auth_header(@user)
    end

    assert_response 200
  end

  test "should show like" do
    get like_url(@like), as: :json, headers: auth_header(@user)
    assert_response :success
  end

  test "should update like" do
    params = {
      tmsId: @tms_id,
      seriesId: @series_id,
      liked: false
    }

    # create a like so we can test that it gets deleted
    Like.create(show_id: @show.id, user_id: @user.id)
    assert_difference('Like.count', -1) do
      post likes_url, params: params, as: :json, headers: auth_header(@user)
    end

    assert_response 200
  end

  test "should destroy like" do
    id = @like.id
    assert @like.persisted?

    delete like_url(@like), as: :json, headers: auth_header(@user)

    refute Like.find_by(id: id)
    assert_response 204
  end
end
