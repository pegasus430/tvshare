require 'test_helper'

class RatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rating = ratings(:one)
  end

  test "should get index" do
    skip "deprecated in favor of shows/ratings"
    get ratings_url, as: :json
    assert_response :success
  end

  test "should create rating" do
    skip "deprecated in favor of shows/ratings"
    assert_difference('Rating.count') do
      post ratings_url, params: { rating: { body: @rating.body, code: @rating.code, show_id: @rating.show_id } }, as: :json
    end

    assert_response 201
  end

  test "should show rating" do
    skip "deprecated in favor of shows/ratings"
    get rating_url(@rating), as: :json
    assert_response :success
  end

  test "should update rating" do
    skip "deprecated in favor of shows/ratings"
    patch rating_url(@rating), params: { rating: { body: @rating.body, code: @rating.code, show_id: @rating.show_id } }, as: :json
    assert_response 200
  end

  test "should destroy rating" do
    skip "deprecated in favor of shows/ratings"
    assert_difference('Rating.count', -1) do
      delete rating_url(@rating), as: :json
    end

    assert_response 204
  end
end
