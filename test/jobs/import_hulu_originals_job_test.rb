require 'test_helper'

class ImportHuluOriginalsJobTest < ActiveJob::TestCase
  test 'imports show data' do
    VCR.use_cassette("hulu_originals") do
      assert_difference('Show.count', 100) do
        ImportHuluOriginalsJob.perform_now
      end
    end

    series = Show.find_by(original_streaming_network: :hulu, original_streaming_network_id: '47b48273-0bac-444e-8b20-4d4a9153eeb7')
    assert_equal 'Marvel\'s Runaways', series.title
    assert_equal 'series', series.entityType
    assert_nil series.tmsId

    movie = Show.find_by(original_streaming_network: :hulu, original_streaming_network_id: '1025a39a-f965-4a95-87f9-c0fb65840f15')
    assert_equal 'Midnight Kiss', movie.title
    assert_equal 'movie', movie.entityType
    assert_nil movie.tmsId
  end
end
