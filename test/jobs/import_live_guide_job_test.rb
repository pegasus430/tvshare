require 'test_helper'

class ImportLiveGuideJobTest < ActiveJob::TestCase
  setup do
    # Freeze the time for consistent testing
    Timecop.freeze('2021-04-26T20:00:00-04:00')
  end

  teardown do
    # Unfreeze the time after the test runs
    Timecop.return
  end

  test 'new shows are imported from the live guide' do
    # Testing that new shows are added
    VCR.use_cassette("gracenote_live_guide") do
      assert_difference('Show.count', 151) do
        ImportLiveGuideJob.perform_now
      end
    end

    # Testing that existing shows aren't re-added
    VCR.use_cassette("gracenote_live_guide") do
      assert_no_difference('Show.count') do
        ImportLiveGuideJob.perform_now
      end
    end
  end

  test 'imports show data' do
    VCR.use_cassette("gracenote_live_guide") do
      assert_difference('Show.count', 151) do
        ImportLiveGuideJob.perform_now
      end
    end

    show = Show.find_by(tmsId: 'SH016441980000')
    assert_equal 'Show', show.entityType
    assert_equal '2012-11-13', show.origAirDate.to_s
    assert_equal '2012-11-13', show.releaseDate.to_s
    assert_equal 2012, show.releaseYear
    assert_equal '9580970', show.rootId
    assert_equal '9580970', show.seriesId
    assert_equal 'Series', show.subType
    assert_equal 'ESPN Goal Line and ESPN Buzzer Beater', show.title
    assert_equal 'en', show.titleLang
    assert_equal 'http://wewe.tmsimg.com/assets/p9580970_st_v5_aa.jpg', show.preferred_image_uri
    assert_equal nil, show.genres
    assert_equal ['GLBB'], show.networks.pluck(:name)
  end

  test 'raises an exception if API key is not found' do
    # temporarily nullify TMS_API_KEY to simulate a missing API key
    original_api_key = ENV['TMS_API_KEY']
    ENV['TMS_API_KEY'] = nil

    exception = assert_raises RuntimeError do
      ImportLiveGuideJob.perform_now
    end

    assert_equal 'TMS_API_KEY not found, can not import live guide', exception.message

    # Reassign TMS_API_KEY
    ENV['TMS_API_KEY'] = original_api_key
  end
end
