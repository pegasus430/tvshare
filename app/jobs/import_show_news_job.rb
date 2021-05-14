## This is deprecated

class ImportShowNewsJob < ApplicationJob
  attr_accessor :show
  queue_as :default

  def perform(show)
    @show = show
    perform_search_query
    api_response = retrieve_search_results

    # If there was an error, raise an exception.
    if api_response.has_key?('messages')
      raise api_response['messages'].to_sentence
    end

    api_response.each do |(key, stories)|
      get_nested_array(stories).each do |story_data|
        import_story(story_data)
      end
    end
  end

  def import_story(story_data)
    story = Story.find_or_initialize_by(url: story_data.dig('url'))
    story.title = story_data.dig('title')&.strip
    story.description = story_data.dig('description')&.strip
    story.source = story_data.dig('source')
    story.image_url = story_data.dig('image')
    story.published_at = story_data.dig('publish_date')
    story.show_id = show.id
    story.save
  end

  def perform_search_query
    HTTParty.put("#{news_api_host}/#{show.news_query_key}", {
      body: show.news_query.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    })
  end

  def retrieve_search_results
    HTTParty.get("#{news_api_host}/#{show.news_query_key}")
  end

  def news_api_host
    Rails.env.development? ? "http://localhost:8000" : "https://tvchat-news-search.herokuapp.com"
  end

  #
  # The data returned from the news search API is a nested data structure
  # where each value can either be an array or a hash. For now, cycle through
  # each nested hash and return a flattened array of all arrays.
  #
  def get_nested_array(value)
    if value.kind_of?(Array)
      value
    elsif value.kind_of?(Hash)
      value.flat_map do |(key, _value)|
        get_nested_array(_value)
      end
    else
      raise 'Expected value to be Array or Hash'
    end
  end
end
