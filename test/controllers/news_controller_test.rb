require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    VCR.use_cassette('bing_recent_news') do
      get news_index_url
    end

    assert_response :success
    assert_equal %w[id title description source image_url published_at url likes_count likes_count_by_followed_users show_id published_at_formatted shares_count iframe_enabled].sort, json_response.first.keys.sort
  end
end
