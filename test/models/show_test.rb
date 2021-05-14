require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  setup do
    @show = shows(:one)
    @user_1 = users(:one)
    @user_2 = users(:two)
    @user_3 = users(:three)
  end

  test "tmsId must be unique" do
    tms_id = '123'
    show_1 = Show.create(tmsId: tms_id)
    show_2 = Show.new(tmsId: tms_id)

    assert show_1.valid?
    refute show_2.valid?
  end

  test "original_streaming_network_id must be unique per original_streaming_network" do
    original_streaming_network_id = '123'
    show_1 = Show.create(original_streaming_network_id: original_streaming_network_id, original_streaming_network: :netflix)
    show_2 = Show.new(original_streaming_network_id: original_streaming_network_id, original_streaming_network: :netflix)
    show_3 = Show.new(original_streaming_network_id: original_streaming_network_id, original_streaming_network: :hulu)

    assert show_1.valid?
    refute show_2.valid?

    # this show is on another streaming network, so it should be valid
    assert show_3.valid?
  end

  test "set_popularity_score for movies" do
    show = Show.create(tmsId: "MV123", stories_count: 1, likes_count: 2, comments_count: 3, awards: [Award.new])
    show.set_popularity_score
    assert_equal -3, show.popularity_score
  end

  test "set_popularity_score for news" do
    show = Show.create(tmsId: "SH123News", seriesId: '123News', stories_count: 1, likes_count: 2, comments_count: 3, awards: [Award.new], genres: ['News'])
    show.set_popularity_score
    assert_equal -17, show.popularity_score
  end

  test "set_popularity_score for series/episodes" do
    series = Show.create(seriesId: 123, tmsId: 'SH1234', stories_count: 5, likes_count: 5, comments_count: 3, awards: [Award.new])
    episode_1 = Show.create(seriesId: 123, tmsId: 'EP123', stories_count: 2, likes_count: 2, comments_count: 2, awards: [Award.new])
    episode_2 = Show.create(seriesId: 123, tmsId: 'EP124', stories_count: 10, likes_count: 10, comments_count: 10, awards: [Award.new])

    # The scores are averaged from all episodes
    [series, episode_1, episode_2].each do |show|
      show.set_popularity_score
      assert_equal 23, show.popularity_score
    end
  end

  test "does not allow paid programs from being imported" do
    show = Show.new(subType: 'Paid Programming')
    refute show.save
    assert "can't be Paid Programming", show.errors[:subType].first
  end

  test "parent program returns parent tv show for episode" do
    parent = Show.create(tmsId: 'SH123', rootId: 123, seriesId: 123)
    show = Show.create(tmsId: 'EP123', seriesId: 123)
    movie = Show.create(tmsId: 'MV123')

    assert_equal parent.id, show.parent_program.id
    assert_equal parent.id, parent.parent_program.id # return itself
    refute movie.parent_program.present? # no parent program
  end

  test "rating percentage is calculated after each rate" do
    @show.rate(@user_1, 'love')
    @show.rate(@user_2, 'like')
    @show.rate(@user_3, 'dislike')

    assert_equal 33.33, @show.rating_percentage_cache['love']
    assert_equal 33.33, @show.rating_percentage_cache['like']
    assert_equal 33.33, @show.rating_percentage_cache['dislike']

    assert_equal 3, @show.cached_votes_total
    assert_equal 1, @show.cached_votes_score
  end
end
