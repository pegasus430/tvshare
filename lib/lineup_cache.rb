class LineupCache
  PAGE_SIZE = 25
  EXPIRATION_DAYS = Rails.env.production? ? 7 : 1
  TOTAL_LINEUP_DAYS = 5
  SUPPORTED_TIME_ZONES = ['EST', 'CST', 'MDT', 'AKDT', 'HST', 'PDT']

  def initialize(lineup: nil, timezone: 'EST')
    @lineup = lineup || get_lineup_by_timezone(timezone)
    @cache_key = "lineup_#{@lineup}"
    @show_map = {}
  end

  def cache(clear_cache: false)
    Rails.cache.fetch(@cache_key, expires_in: EXPIRATION_DAYS.days, force: clear_cache) do
      get_max_live_guide
    end
  end

  def get_max_live_guide
    station_airings = {}
    get_importable_timeslots.each_with_object([]) do |timeslot, array|
      get_guide_timeslot(timeslot).each do |station|
        stationId = station['stationId']
        if station_airings[stationId]
          station_airings[stationId]['airings'] = station_airings[stationId]['airings'].concat(station['airings'])
        else
          station_airings[stationId] = station
        end
      end
    end

    station_airings.values
  end

  def get_guide_timeslot(start_time)
    response = HTTParty.get(get_lineup_api_url(start_time))
    live_data = JSON.parse(response.body)

    tms_ids = extract_tms_ids(live_data)
    extract_shows(tms_ids)
    apply_show_overrides(live_data)
  end

  def live_now(station_id: nil)
    guide = self.cache
    current_time = Time.now.utc.iso8601

    guide.map do |station|
      next if station_id.present? && station['stationId'].to_s != station_id.to_s
      current_airing = station['airings'].find do |airing|
        current_time >= airing['startTime'] && current_time <= airing['endTime']
      end

      if current_airing.present?
        station['airings'] = [current_airing]
        station
      end
    end.compact
  end

  def upcoming(station_id: nil)
    guide = self.cache
    current_time = Time.now.utc.iso8601

    guide.map do |station|
      next if station_id.present? && station['stationId'].to_s != station_id.to_s
      upcoming_index = station['airings'].find_index do |airing|
        current_time <= airing['startTime']
      end
      station['airings'] = station['airings'][upcoming_index..-1]
      station
    end.compact
  end

  private

  def get_lineup_by_timezone(timezone)
    case timezone&.upcase
    when 'PDT', 'PST'
      'USA-DITV803-DEFAULT' # Los Angeles
    when 'HST', 'HDT'
      'USA-DITV744-DEFAULT' # Honolulu
    when 'AKDT', 'AKST'
      'USA-DITV743-DEFAULT' # Anchorage
    when 'MDT', 'MST'
      'USA-DITV753-DEFAULT' # Phoneix (prescott)
    when 'CST', 'CDT'
      'USA-DITV602-DEFAULT' # Chicago
    when 'EST', 'EDT'
      'USA-DITV501-DEFAULT' # New York
    else
      'USA-DITV-DEFAULT'    # Default
    end
  end

  # returns timestamps in 6 hour increments for the next 14 days
  def get_importable_timeslots
    start_time = Time.current.beginning_of_hour
    end_time = TOTAL_LINEUP_DAYS.days.from_now.end_of_day

    timeslots = []
    (start_time.to_i..end_time.to_i).step(6.hours) do |timeslot|
      timeslots.push(Time.at(timeslot))
    end

    timeslots
  end

  def extract_tms_ids(live_data)
    live_data.each_with_object(Set.new) do |station, set|
      station['airings'].each do |airing|
        set.add(airing['program']['tmsId'])
      end
    end
  end

  def extract_shows(tms_ids)
    Show.includes(:parent_program)
      .select(:id, :tmsId, :popularity_score, :preferred_image_uri, :seriesId, :rootId)
      .where(tmsId: tms_ids - @show_map.keys)
      .order('popularity_score DESC')
      .find_each do |show|
        @show_map[show.tmsId] = show
      end
  end

  # use our preferried image, assign popularity_score, etc.
  def apply_show_overrides(live_data)
    live_data.map do |station|
      station['airings'] = station['airings'].map do |airing|
        program = @show_map[airing['program']['tmsId']]
        # We have our own "preferredImage" logic, so let's use it when available.
        airing['program']['preferredImage'] = { 'uri' => program&.preferred_image_uri || airing.dig('program', 'preferredImage', 'uri') }
        airing['program']['preferredImage']['uri'] = CGI.unescape(airing.dig('program', 'preferredImage', 'uri'))
        airing['program']['popularity_score'] = program&.parent_program&.popularity_score || program&.popularity_score
        airing['program'] = extract_program_data(airing['program'])
        extract_airing_data(airing)
      end

      extract_station_data(station)
      station
    end
  end

  def extract_station_data(station)
    station['preferredImage'] = { uri: CGI.unescape(station['preferredImage']['uri']) }
    station.slice(*%w(stationId callSign affiliateCallSign preferredImage airings))
  end

  def extract_airing_data(airing)
    airing['channel'] = airing['channels']&.first if airing['channels'].present? && airing['channel'].blank?
    airing.slice(*%w(stationId preferredImage program startTime endTime duration channel))
  end

  def extract_program_data(program)
    program.slice(*%w(tmsId rootId seriesId title genres preferredImage popularity_score))
  end

  def get_lineup_api_url(start_time)
    end_time = start_time + 6.hours
    station_ids = Networks::LIST.map { |n| n[:stationId] }.join(',')
    url = "https://data.tmsapi.com/v1.1/lineups/#{@lineup}/grid?startDateTime=#{start_time.iso8601}&endDateTime=#{end_time.iso8601}&stationId=#{station_ids}&imageAspectTV=4x3&imageSize=Md&imageText=true&excludeChannels=ppv,adult&api_key=#{ENV['TMS_API_KEY']}"
  end
end
