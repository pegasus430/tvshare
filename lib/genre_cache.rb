class GenreCache
  include Rails.application.routes.url_helpers
  PAGE_SIZE = 250
  EXPIRATION_DAYS = 7

  def initialize
    @used_tms_ids = Set.new
  end

  def self.cache_all(clear_cache: false)
    # Cache genre-overview (all-network)
    self.fetch(station_id: nil, clear_cache: clear_cache)

    # Caching for networks and online streaming networks
    station_ids = Network.active.pluck(:station_id) + Show.original_streaming_networks.keys
    station_ids.each do |station_id|
      # Cache the genre overview
      self.fetch(station_id: station_id, clear_cache: clear_cache)

      # Cache each genre and all pages
      self.cache_network_genres(station_id: station_id, clear_cache: clear_cache)
    end
  end

  # Cache all pages for all genres for a given network
  def self.cache_network_genres(station_id:, clear_cache: false)
    genres = GenreMap.to_h

    genres.to_h.keys.each do |genre|
      page = 1
      total_page = 0
      begin
        json_string = GenreCache.fetch_genre(page: page, station_id: station_id, genre: genre, clear_cache: clear_cache)
        json = JSON.parse(json_string)
        page += 1
        total_pages =  json.dig('pagination', 'total_pages')
      end while page < total_pages&.to_i
    end
  end

  def self.fetch(page: 1, station_id: nil, clear_cache: false)
    Rails.cache.fetch("genres_station_#{station_id}_page_#{page}", expires_in: EXPIRATION_DAYS.days, force: clear_cache) do
      GenreCache.new.all_genres(page: page, station_id: station_id).to_json
    end
  end

  def self.fetch_genre(page:, station_id:, genre:, clear_cache: false)
    cache_key = "genre_#{genre.downcase.gsub(' ', '_')}_station_#{station_id}_page_#{page}"
    Rails.cache.fetch(cache_key, expires_in: EXPIRATION_DAYS.days, force: clear_cache) do
      GenreCache.new.genre(page: page, station_id: station_id, genre: genre).to_json
    end
  end


  def self.fetch_network(page: 1, station_id: nil, clear_cache: false)
    Rails.cache.fetch("genres_station_#{station_id}_page_#{page}", expires_in: EXPIRATION_DAYS.days, force: clear_cache) do
      GenreCache.new.all_genres(page: page, station_id: station_id).to_json
    end
  end

  def all_genres(page: 1, station_id: nil)
    GenreMap.to_h.reduce({}) do |memo, (title, sub_genres)|
      shows = Show.distinct.parent_shows
        .where.not(tmsId: @used_tms_ids)
        .select(:id, :title, :genres, :preferred_image_uri, :tmsId, :seriesId, :rootId, :popularity_score, :original_streaming_network)
        .by_genres(sub_genres)
        .order(popularity_score: :desc, id: :desc)
        .yield_self do |show|
          if station_id.blank?
            show.joins(:networks)
          elsif station_id.to_i.zero? # string, not an integer
            show.where(original_streaming_network: station_id&.downcase)
          else
            show.joins(:networks).where(networks: { station_id: station_id })
          end
        end
        .page(page)
        .per(PAGE_SIZE)

        shows.each { | show| @used_tms_ids.add(show.tmsId) }

        memo[title] = {
          results: shows.map { |show| format_show(show) },
          pagination: {
            total_count: shows.total_count,
            next_page: (genre_shows_genres_path(title, page: 2, station_id: station_id) unless shows.last_page?)
          }
        }
      memo
    end
  end

  def format_show(show)
    {
      id: show.id,
      title: show.title,
      genres: show.genres,
      preferred_image_uri: show.preferred_image_uri,
      tmsId: show.tmsId,
      rootId: show.rootId,
      popularity_score: show.popularity_score,
      callSign: show.formatted_networks.compact.join(', ')
    }
  end

  def genre(page: 1, station_id: nil, genre: nil)
    sub_genres = GenreMap.to_h[genre]
    shows = Show.parent_shows
      .select(:id, :title, :genres, :preferred_image_uri, :tmsId, :seriesId, :rootId, :popularity_score, :original_streaming_network)
      .by_genres(sub_genres)
      .order(popularity_score: :desc, id: :desc)
      .yield_self do |show|
        if station_id.blank?
          show.joins(:networks)
        elsif station_id.to_i.zero? # string, not an integer
          show.where(original_streaming_network: station_id&.downcase)
        else
          show.joins(:networks).where(networks: { station_id: station_id })
        end
      end
      .distinct
      .page(page)
      .per(PAGE_SIZE)

      {
        genre: genre,
        results: shows.map { |show| format_show(show) },
        pagination: {
          total_count: shows.total_count,
          current_page: shows.current_page,
          total_pages: shows.total_pages,
          page_size: shows.limit_value,
          next_page: (genre_shows_genres_path(genre, page: page.to_i + 1, station_id: station_id) unless shows.last_page?)
        }
      }
    end
  end
