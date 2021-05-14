class ImportNewsJob < ApplicationJob
  URL = 'https://api.cognitive.microsoft.com/bing/v7.0/news?category=Entertainment_MovieAndTV'
  queue_as :default

  def perform(*args)
    api_response = HTTParty.get(URL, headers: {
      'Ocp-Apim-Subscription-Key' => ENV['BING_API_KEY']
    })
    api_response['value'].each do |story|
      import_story(story)
    end
  end

  def import_story(story_data)
    story = Story.find_or_initialize_by(url: story_data.dig('url'))
    story.title = story_data.dig('name').strip
    story.description = story_data.dig('description').strip
    story.source = story_data.dig('provider')[0]['name']
    story.image_url = story_data.dig('image', 'thumbnail', 'contentUrl')
    story.published_at = story_data.dig('datePublished')
    story.save
  end
end
