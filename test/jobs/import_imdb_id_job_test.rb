require 'test_helper'

class ImportImdbIdJobTest < ActiveJob::TestCase
  setup do
    @movie_tms_id = 'MV003358300000'
    @series_tms_id = 'SH006883590000'
  end

  test 'IMDB ID is imported for series' do
    show = Show.create(tmsId: @series_tms_id, seriesId: @series_tms_id)

    VCR.use_cassette("import_imdb_#{@series_tms_id}") do
      ImportImdbIdJob.perform_now(show)
    end

    assert_equal 'tt0412142', show.reload.imdb_id
  end

  test 'IMDB ID is imported for movie' do
    show = Show.create(tmsId: @movie_tms_id)

    VCR.use_cassette("import_imdb_#{@movie_tms_id}") do
      ImportImdbIdJob.perform_now(show)
    end

    assert_equal 'tt1464174', show.reload.imdb_id
  end
end
