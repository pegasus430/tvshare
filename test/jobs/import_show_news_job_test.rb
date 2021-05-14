require 'test_helper'

class ImportShowNewsJobTest < ActiveJob::TestCase
  test 'imports news story data' do
    show = Show.new(title: 'Jeopardy!')

    VCR.use_cassette("bing_jeopardy_news") do
      assert_difference('Story.count', 4) do
        ImportShowNewsJob.perform_now(show)
      end
    end

    story = Story.find_by(url: 'https://www.clickondetroit.com/community/2020/09/11/monday-season-premieres-of-wheel-of-fortune-jeopardy-and-inside-edition/')

    assert_equal "Monday season premieres of Wheel of Fortune, Jeopardy!, and Inside Edition", story.title
    assert_equal 'Monday season premieres of , Jeopardy!, and Inside Edition Catch the brand new episodes this Monday. Madeline Allen, Creative Services Associate Producer', story.description
    assert_equal 'clickondetroit.com', story.source
    assert_equal 'https://www.bing.com/th?id=ON.51C2565C8FD7477E83308B9574E2B20D&pid=News', story.image_url
    assert_equal DateTime.parse('Fri, 11 Sep 2020 21:57:00 UTC +00:00'), story.published_at
  end
end
