require 'test_helper'

class ImportShowJobTest < ActiveJob::TestCase
  setup do
    @movie_tms_id = 'MV003358300000'
    @tms_id = 'SH006883590000'
    @series_id = '185044'
  end

  test 'show is imported via TMS ID and Gracenote API' do
    VCR.use_cassette(@tms_id) do
      assert_difference('Show.count', 268) do
        ImportShowJob.perform_now(tmsId: @tms_id)
      end
    end

    show = Show.find_by(tmsId: @tms_id)
    assert_equal 'House', show.title
    assert_equal 'Show', show.entityType
    assert_equal '2004-11-16', show.origAirDate.to_s
    assert_equal '2004-11-16', show.releaseDate.to_s
    assert_equal 2004, show.releaseYear
    assert_equal 185044, show.rootId
    assert_equal '185044', show.seriesId
    assert_equal 'Series', show.subType
    assert_equal 'en', show.titleLang
    assert_equal ['Drama', 'Mystery', 'Medical'], show.genres
    assert_equal 'https://wewe.tmsimg.com/assets/p7892174_b1t_h9_aa.jpg?w=720&h=540', show.preferred_image_uri

    assert_equal 11, show.cast.count
    assert_equal ({
      "billingOrder"=>"01",
      "role"=>"Actor",
      "nameId"=>"87269",
      "personId"=>"87269",
      "name"=>"Hugh Laurie",
      "characterName"=>"Dr. Gregory House"
      }), show.cast.first

    assert_equal 4, show.crew.count
    assert_equal ({
      "billingOrder"=>"01",
      "role"=>"Executive Producer",
      "nameId"=>"71245",
      "personId"=>"71245",
      "name"=>"Paul Attanasio"
    }), show.crew.first

    assert_equal 37, show.awards.count
    award = show.awards.find { |a| a.awardId == '4' }
    assert_equal "4", award.awardId
    assert_equal "78", award.awardCatId
    assert_equal "Emmy (Primetime)", award.awardName
    assert_equal "Emmy (Primetime)", award.name
    assert_equal "2011", award.year
    assert_equal "Outstanding Lead Actor in a Drama Series", award.category

    assert_equal 3, show.recommendations.count
    recommendation = show.recommendations.find { |a| a.rootId == '185019' }
    assert_equal "185019", recommendation.rootId
    assert_equal "Grey's Anatomy", recommendation.title
    assert_equal "SH007322830000", recommendation.tmsId

    assert_equal 6, show.ratings.count
    rating = show.ratings.first
    assert_equal "USA Parental Rating", rating.body
    assert_equal "TVPG", rating.code
  end

  test 'show and episodes are imported via Series ID and Gracenote API' do
    VCR.use_cassette("series_#{@series_id}") do
      assert_difference('Show.count', 268) do
        ImportShowJob.perform_now(seriesId: @series_id)
      end
    end

    show = Show.find_by(tmsId: @tms_id)
    assert_equal 'House', show.title
    assert_equal 'Show', show.entityType
    assert_equal '2004-11-16', show.origAirDate.to_s
    assert_equal '2004-11-16', show.releaseDate.to_s
    assert_equal 2004, show.releaseYear
    assert_equal 185044, show.rootId
    assert_equal '185044', show.seriesId
    assert_equal 'Series', show.subType
    assert_equal 'en', show.titleLang
    assert_equal ['Drama', 'Mystery', 'Medical'], show.genres
    assert_equal 'Hugh Laurie', show.cast.first['name']
    assert_equal 'Paul Attanasio', show.crew.first['name']
    assert_equal 'https://wewe.tmsimg.com/assets/p7892174_b1t_h6_aa.jpg', show.preferred_image_uri
  end

  test 'movies are imported via TMS ID API' do
    VCR.use_cassette("tms_id#{@movie_tms_id}") do
      assert_difference('Show.count', 1) do
        ImportShowJob.perform_now(tmsId: @movie_tms_id)
      end
    end

    show = Show.find_by(tmsId: @movie_tms_id)
    assert_equal 'Big Mommas: Like Father, Like Son', show.title
    assert_equal 'Movie', show.entityType
    assert_equal nil, show.origAirDate
    assert_equal '2011-02-18', show.releaseDate.to_s
    assert_equal 2011, show.releaseYear
    assert_equal 8329393, show.rootId
    assert_equal nil, show.seriesId
    assert_equal 'Feature Film', show.subType
    assert_equal 'en', show.titleLang
    assert_equal ['Comedy'], show.genres
    assert_equal 'https://wewe.tmsimg.com/assets/p8329393_v_h9_aa.jpg', show.preferred_image_uri
  end
end
