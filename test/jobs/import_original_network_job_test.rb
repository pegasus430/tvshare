require 'test_helper'

class ImportOriginalNetworkJobTest < ActiveJob::TestCase

  test 'Imports original network' do
    tms_id = 'SH006883590000'
    show = Show.create(tmsId: tms_id, imdb_id: 'tt0412142')
    network = Network.create(display_name: 'FOX')

    VCR.use_cassette("import_network_#{tms_id}") do
      ImportOriginalNetworkJob.perform_now(show)
    end

    assert_equal 1, show.networks.count
    assert_equal network.id, show.networks.first.id
  end

  test 'Imports original streaming network (netflix)' do
    tms_id = 'SH026423250000'
    show = Show.create(tmsId: tms_id, imdb_id: 'tt0367279')

    VCR.use_cassette("import_network_#{tms_id}") do
      ImportOriginalNetworkJob.perform_now(show)
    end

    assert_equal 0, show.networks.count
    assert show.netflix?
    refute show.hulu?
    refute show.prime?
  end

  test 'Imports original streaming network (hulu)' do
    tms_id = 'SH005546930000'
    show = Show.create(tmsId: tms_id, imdb_id: 'tt5834204')

    VCR.use_cassette("import_network_#{tms_id}") do
      ImportOriginalNetworkJob.perform_now(show)
    end

    assert_equal 0, show.networks.count
    assert show.hulu?
    refute show.prime?
    refute show.netflix?
  end

  test 'Imports original streaming network (prime)' do
    tms_id = 'SH032542490000'
    show = Show.create(tmsId: tms_id, imdb_id: 'tt1190634')

    VCR.use_cassette("import_network_#{tms_id}") do
      ImportOriginalNetworkJob.perform_now(show)
    end

    assert_equal 0, show.networks.count
    assert show.prime?
    refute show.hulu?
    refute show.netflix?
  end

  test 'When show is not found via IMDB ID' do
    show = Show.create(tmsId: '0123', imdb_id: 'tt0094226')

    VCR.use_cassette("import_network_not_found") do
      ImportOriginalNetworkJob.perform_now(show)
    end

    assert_equal 0, show.networks.count
    refute show.hulu?
    refute show.netflix?
    refute show.prime?
  end
end
