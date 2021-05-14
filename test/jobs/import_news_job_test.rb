require 'test_helper'

class ImportNewsJobTest < ActiveJob::TestCase
  test 'imports news story data' do
    VCR.use_cassette("bing_recent_news") do
      assert_difference('Story.count', 10) do
        ImportNewsJob.perform_now
      end
    end

    story = Story.find_by(url: 'https://www.hollywoodreporter.com/live-feed/netflixs-big-mouth-adds-ayo-edibiri-to-take-over-for-jenny-slate')

    assert_equal "Netflix's 'Big Mouth' Adds Ayo Edibiri to Take Over for Jenny Slate", story.title
    assert_equal 'The move comes two months after Slate stepped away from voicing a Black character on the animated series. Netflix has found a new actor to voice the character Missy in its animated comedy Big Mouth.', story.description
    assert_equal 'The Hollywood Reporter', story.source
    assert_equal 'https://www.bing.com/th?id=ON.9DD5502F02008306A5DF8171C12AFD42&pid=News', story.image_url
    assert_equal DateTime.parse('Fri, 28 Aug 2020 15:11:00 UTC +00:00'), story.published_at
  end

end
