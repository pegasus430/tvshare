class ScrapeNewsStoryJob < ApplicationJob
  attr_accessor :show, :url
  queue_as :low_priority
  sidekiq_options retry: 0

  def perform(show, url)
    @show = show
    @url = url
    domain = get_source_domain
    return false if domain.blank?
    rate_limiter = DomainRateLimiter.new(domain)

    scraping_allowed = Timeout.timeout(4) { Robotstxt.allowed?(url, 'NewsBot') }

    if !scraping_allowed
      puts "Scraping denied: #{url}"
    elsif rate_limiter.can_scrape?
      import
      rate_limiter.reset
    else
      puts "Scrape #{get_source_domain} at #{rate_limiter.next_scraping_time}"
      self.class.set(wait_until: rate_limiter.next_scraping_time).perform_later(show, url)
    end
  end

  def import
    metadata = get_story_metadata(url)
    return if metadata['og:locale'].present? && !metadata['og:locale']&.starts_with?('en')
    return unless metadata['og:description'].present?


    import_story({
      url: url,
      title: metadata['og:title'],
      source: metadata['og:site_name'],
      description: metadata['og:description'],
      image_url: metadata['og:image'],
      published_at: metadata['article:published_time'] || show.origAirDate
    })
  end

  def import_story(story_data)
    story = Story.find_or_initialize_by(url: story_data[:url])
    story.title = story_data[:title]
    story.description = story_data[:description]
    story.source = story_data[:source]
    story.image_url = story_data[:image_url]
    story.published_at = story_data[:published_at]
    story.show_id = show.id
    story.save
  rescue => e
    puts e
  end

  def get_source_domain
    @_get_source_domain = URI.parse(url)&.host&.split('www.')&.last
  end

  def get_story_metadata(url)
    response = ''
    Timeout.timeout(5) do
      response = HTTParty.get(url)
    end
    doc = Nokogiri::HTML.parse(response.body)
    properties = {}

    doc.css('meta').each do |meta|
      if meta.attribute('property') && meta.attribute('property').to_s.match(/^og:(.+)$/i) || meta.attribute('property').to_s.match(/^article:(.+)$/i)
        decoded_content = CGI.unescapeHTML(meta.attribute('content').to_s)
        decoded_content = ActionView::Base.full_sanitizer.sanitize(decoded_content)
        properties[meta.attribute('property').to_s] = decoded_content
      end
    end

    properties

    # If the article couldn't be retrieved or parsed, move on to the next URL.
  rescue => e
    puts e
    {}
  end
end
