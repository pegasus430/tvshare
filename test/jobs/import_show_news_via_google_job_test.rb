require 'test_helper'

class ImportShowNewsViaGoogleJobTest < ActiveJob::TestCase
  test 'imports news story data' do
    show = Show.create(title: 'Modern Family', origAirDate: '2012-10-31', tmsId: 'rails', seriesId: '3560360', episodeTitle: 'Yard Sale', seasonNum: '4', episodeNum: '6')

    Timecop.freeze("2021-05-02 20:22:07.047285 -0400") do
      VCR.use_cassette("google_modern_family") do
        assert_difference('Story.count', 3) do
          ImportShowNewsViaGoogleJob.perform_now(show)
        end
      end
    end

    story = show.stories.find_by(url: 'https://www.vulture.com/2012/11/modern-family-recap-season-4-episode-6.html')
    assert_equal "Modern Family Recap: Puppet Show by Demand", story.title
    assert_equal 'A yard sale at the Pritchett-Delgado headquarters — what a wonderful way to get the entire dysfunctional Modern Family clan together.', story.description
    assert_equal 'Vulture', story.source
    assert_equal 'https://pyxis.nymag.com/v1/imgs/12d/851/7793594b3b2291ef64ab6a635fde519f6e-01-modern-family.1x.rsocial.w1200.jpg', story.image_url
    assert_equal DateTime.parse('Wed, 31 Oct 2012 00:00:00 UTC +00:00'), story.published_at
  end
end
