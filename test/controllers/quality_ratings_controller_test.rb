require 'test_helper'

class QualityRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quality_rating = quality_ratings(:one)
  end

  test "should get index" do
    skip "deprecated in favor of shows/ratings"
    get quality_ratings_url, as: :json
    assert_response :success
  end

  test "should create quality_rating" do
    skip "deprecated in favor of shows/ratings"
    assert_difference('QualityRating.count') do
      post quality_ratings_url, params: { quality_rating: { ratingsBody: @quality_rating.ratingsBody, show_id: @quality_rating.show_id, value: @quality_rating.value } }, as: :json
    end

    assert_response 201
  end

  test "should show quality_rating" do
    skip "deprecated in favor of shows/ratings"
    get quality_rating_url(@quality_rating), as: :json
    assert_response :success
  end

  test "should update quality_rating" do
    skip "deprecated in favor of shows/ratings"
    patch quality_rating_url(@quality_rating), params: { quality_rating: { ratingsBody: @quality_rating.ratingsBody, show_id: @quality_rating.show_id, value: @quality_rating.value } }, as: :json
    assert_response 200
  end

  test "should destroy quality_rating" do
    skip "deprecated in favor of shows/ratings"
    assert_difference('QualityRating.count', -1) do
      delete quality_rating_url(@quality_rating), as: :json
    end

    assert_response 204
  end
end
