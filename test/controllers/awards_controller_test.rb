require 'test_helper'

class AwardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @award = awards(:one)
  end

  test "should get index" do
    get awards_url, as: :json
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post awards_url, params: { award: { awardCatId: @award.awardCatId, awardId: @award.awardId, awardName: @award.awardName, category: @award.category, name: @award.name, show_id: @award.show_id, year: @award.year } }, as: :json
    end

    assert_response 201
  end

  test "should show award" do
    get award_url(@award), as: :json
    assert_response :success
  end

  test "should update award" do
    patch award_url(@award), params: { award: { awardCatId: @award.awardCatId, awardId: @award.awardId, awardName: @award.awardName, category: @award.category, name: @award.name, show_id: @award.show_id, year: @award.year } }, as: :json
    assert_response 200
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete award_url(@award), as: :json
    end

    assert_response 204
  end
end
