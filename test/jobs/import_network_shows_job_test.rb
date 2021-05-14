require 'test_helper'

class ImportNetworkShowsJobTest < ActiveJob::TestCase
  setup do
    network = Network.create(station_id: 16689)
    VCR.use_cassette("network_shows") do
      Timecop.freeze('2020-12-17') do
        ImportNetworkShowsJob.perform_now(network)
      end
    end
  end

  test "imports network shows" do

    show = Show.find_by(tmsId: 'EP000191907092')
    assert_equal 1, show.networks.count
    assert_equal '16689', show.networks.first.station_id
  end
end
