# This is deprecated
require 'whatlanguage'

class ImportShowNewsFromBingWebSearchJob < ApplicationJob
  RESULT_COUNT = 12
  attr_accessor :show
  queue_as :low_priority

  def perform(show)
    @show = show
    import
    show.imported_news_at = Time.current
    show.save
  end

  def import
    existing_show_stories_urls = Set.new(show.stories.pluck(:url))
    get_search_terms(show).each do |search_term|
      retrieve_search_results(search_term).each do |url|
        next if existing_show_stories_urls.include?(url)
        ScrapeNewsStoryJob.perform_later(show, url)
        existing_show_stories_urls.add(url)
      end

      sleep 1 # rate-limit
    end
  end

  def get_search_terms(show)
    if show.tmsId.starts_with?('EP')
      [
        "#{show.title} season #{show.seasonNum} episode #{show.episodeNum}",
        "#{show.title} #{show.season_and_episode_number}",
        "#{show.title} season #{show.seasonNum} episode #{show.episodeNum} review",
        "#{show.title} #{show.season_and_episode_number} recap",
        "#{show.title} season #{show.seasonNum} episode #{show.episodeNum} synopsis",
        "#{show.title} #{show.season_and_episode_number} synopsis"
      ]
    elsif show.tmsId.starts_with?('MV')
      [
        "#{show.title} review #{show.cast&.first&.dig('characterName') || show.releaseYear}",
        "#{show.title} review #{show.cast&.first&.dig('name') || show.releaseYear}"
      ].uniq
    else
      ["#{show.title} review"]
    end
  end

  def retrieve_search_results(query)
    url = "https://www.bing.com/search?q=\"#{CGI::escape(query)}\"&count=#{RESULT_COUNT}"
    response = HTTParty.get(url, {
      headers: { 'User-Agent' => 'Mozilla/5.0 (compatible; bingbot/2.0; +https://www.bing.com/bingbot.htm)' }
      })

    html = response.body
    doc = Nokogiri::HTML.parse(html)
    doc.css('#b_results h2 a')&.map { |a| a['href'] } || []
  rescue  => e
    puts e
    []
  end
end
