require 'test_helper'

class Shows::OriginalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @non_original_show = shows(:one)
    @hulu_show = shows(:hulu)
    @netflix_show = shows(:netflix)
  end

  test "returns all original shows on index" do
    get shows_originals_url, as: :json
    assert_response :success

    assert_equal 2, json_response.count
    assert_equal [@hulu_show.id, @netflix_show.id].sort, json_response.map { |show| show['id'] }.sort
  end

  test "returns network specific originals on show" do
    get network_shows_originals_path(network: :hulu), as: :json
    assert_response :success

    assert_equal 1, json_response.count
    assert_equal @hulu_show.title, json_response[0]['title']
  end
end
