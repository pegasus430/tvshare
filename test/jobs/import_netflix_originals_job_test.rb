require 'test_helper'

class ImportNetflixOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("netflix_originals") do
      assert_difference('Show.count', 1398) do
        ImportNetflixOriginalsJob.perform_now
      end
    end

    show = Show.find_by(original_streaming_network: :netflix, original_streaming_network_id: '80025172')
    assert_equal 'Narcos', show.title
    assert_equal 'series', show.entityType
    assert_equal '2017-09-01', show.releaseDate.to_s
    assert_equal 2017, show.releaseYear
    assert_nil show.tmsId
  end
end
