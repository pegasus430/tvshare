require 'test_helper'

class Shows::GenresControllerTest < ActionDispatch::IntegrationTest
  test "GET index" do
    get shows_genres_url
    assert_response :success

    assert_equal ["Action & Hero Stuff",
      "Adventure Stuff",
      "Cartoon & Animated Stuff",
      "Cooking, Dressing & Decorating",
      "Cops & Lawyers Stuff",
      "Cowboy Stuff",
      "Cultured Stuff",
      "Earth Stuff",
      "Entertainment",
      "Funny Stuff",
      "Game Shows",
      "Guilty Pleasure",
      "Love Stuff",
      "People Talking",
      "Potentially Dramatic",
      "Scary Stuff",
      "Sci-Fi Stuff",
      "Smart Stuff",
      "Soap Opera Stuff",
      "Sports Stuff"
    ], response.parsed_body.keys

    assert_equal ['results', 'pagination'], response.parsed_body["Action & Hero Stuff"].keys
    assert_equal ['total_count', 'next_page'], response.parsed_body["Action & Hero Stuff"]['pagination'].keys
  end

  test "GET show" do
    genre = 'Action & Hero Stuff'
    get genre_shows_genres_url(genre: genre)
    assert_response :success

    assert_equal genre, response.parsed_body['genre']
    assert_equal ["genre", "results", "pagination"], response.parsed_body.keys
    assert_equal ["total_count", "current_page", "total_pages", "page_size", "next_page"], response.parsed_body['pagination'].keys
  end

  test "GET live" do
    get live_shows_genres_url()
    assert_response :moved_permanently
    assert_equal live_guide_url, response.headers['location']
  end

  test "GET upcoming" do
    get upcoming_shows_genres_url()
    assert_response :moved_permanently
    assert_equal upcoming_guide_url, response.headers['location']
  end
end
