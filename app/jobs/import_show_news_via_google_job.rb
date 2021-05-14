class ImportShowNewsViaGoogleJob < ApplicationJob
  attr_accessor :show
  queue_as :low_priority
  sidekiq_options retry: 0

  def perform(show)
    @show = show
    import
    show.imported_news_at = Time.current
    show.save
  end

  def import
    existing_show_stories_urls = Set.new(show.stories.pluck(:url))
    response = request_with_proxy

    if response['organic'].nil?
      puts "News Search Error: No results found for #{show.tmsId} - #{get_query}"
    end

    response['organic']&.each do |result|
      url = result['link']
      next if existing_show_stories_urls.include?(url)
      ScrapeNewsStoryJob.perform_now(show, url)
      existing_show_stories_urls.add(url)
    end
  end

  private

  def request_with_proxy
    query = ERB::Util.url_encode(get_query)
    url = "http://www.google.com/search?q=#{query}&num=15&lum_json=1"

    HTTParty.get(url, {
      http_proxyaddr: 'zproxy.lum-superproxy.io',
      http_proxyport:  22225,
      http_proxyuser: 'lum-customer-c_84e676ff-zone-serp_zone',
      http_proxypass: 'ctucdrzlboyu'
    })
  end

  def get_query
    if show.is_movie?
      return search_term_movie
    end

    if show.origAirDate > Date.today
      search_term_pre_air
    else
      search_term_post_air
    end
  end

  def search_term_pre_air
    before_date = show.origAirDate + 7.days
    after_date = show.origAirDate - 10.days

    %{"#{show.title}" "#{show.episodeTitle}" "Season #{show.seasonNum}" "Episode #{show.episodeNum}"  before:#{before_date} after:#{after_date}}
  end

  def search_term_post_air
    before_date = show.origAirDate + 21.days
    after_date = show.origAirDate - 1.day
    %{"#{show.title}" "#{show.episodeTitle}" "Season #{show.seasonNum}" "Episode #{show.episodeNum}" "Recap" before:#{before_date} after:#{after_date}}
  end

  def search_term_movie
    %{"#{show.title}" review #{show.cast&.first&.dig('name')} "#{show.releaseYear}"}
  end
end
