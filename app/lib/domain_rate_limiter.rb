class DomainRateLimiter
  attr_accessor :domain
  RATE_LIMIT_SECONDS = 15

  def initialize(domain)
    @domain = domain
    @redis = Redis.new(url: ENV['REDIS_URL'])
  end

  def can_scrape?
    if last_scraped_timestamp.nil?
      true
    else
      last_scraped_timestamp + RATE_LIMIT_SECONDS.seconds < Time.now
    end
  end

  def last_scraped_timestamp
    last_scraped = @redis.get(domain).yield_self do |timestamp|
      timestamp.nil? ? nil : Time.parse(timestamp)
    end
  end

  def next_scraping_time
    timestamp = last_scraped_timestamp || Time.now
    timestamp + RATE_LIMIT_SECONDS.seconds
  end

  def reset
    @redis.set(domain, next_scraping_time)
  end
end
