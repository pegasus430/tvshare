class ImportShowJob < ApplicationJob
  queue_as :default

  # We want to import the root program record
  # If the root tmsID ("SH" or "MV", not an individual episode "EP") is available,
  # use it. Otherwise, use the seriesId to get the root tmsId.
  #
  # options example:
  # { tmsId: 'SH002960010000' } or
  # { rootId: '1' } or
  # { seriesId: '184483' }
  def perform(options)
    program = HTTParty.get api_url(options)
    show = import_show(program)

    # if provided a seriesId, import all episodes
    if options[:seriesId].present?
      import_episodes(show.seriesId)
    end
  end

  def import_show(program)
    show = Show.includes(:awards, :ratings, :recommendations).find_or_initialize_by(tmsId: program['tmsId'])

    show.update({
      rootId: program['rootId'],
      seriesId: program['seriesId'],
      subType: program['subType'],
      title: program['title'],
      episodeTitle: program['episodeTitle'],
      episodeNum: program['episodeNum'],
      seasonNum: program['seasonNum'],
      releaseYear: program['releaseYear'],
      releaseDate: program['releaseDate'],
      origAirDate: program['origAirDate'],
      titleLang: program['titleLang'],
      descriptionLang: program['descriptionLang'],
      entityType: program['entityType'],
      genres: program['genres'],
      longDescription: program['longDescription'],
      shortDescription: program['shortDescription'],
      runTime: program['runTime'],
      preferred_image_uri: get_preferred_image_url(program),
      cast: program['cast'],
      crew: program['crew'],
      updated_at: Time.now, # record an attempt to update even if data isn't changed
    })

    assign_awards(show, program) if program['awards']
    assign_ratings(show, program) if program['ratings']
    assign_recommendations(show, program) if program['recommendations']
    show.save
    show
  end

  def get_preferred_image_url(program)
    GetShowImage.new.perform(program['tmsId']) || program.dig('preferredImage', 'uri')
  end

  def assign_awards(show, program)
    show.awards = program['awards'].map do |award|
      Award.find_or_initialize_by({
        awardCatId: award['awardCatId'],
        awardId: award['awardId'],
        awardName: award['awardName'],
        category: award['category'],
        name: award['name'],
        personId: award['personId'],
        year: award['year'],
        won: award['won'],
        show_id: show.id
      })
    end
  end

  def assign_ratings(show, program)
    show.ratings = program['ratings'].map do |rating|
      Rating.find_or_initialize_by({
        body: rating['body'],
        code: rating['code'],
        show_id: show.id
      })
    end
  end

  def assign_recommendations(show, program)
    show.recommendations = program['recommendations'].map do |recommendation|
      Recommendation.find_or_initialize_by({
        rootId: recommendation['rootId'],
        title: recommendation['title'],
        tmsId: recommendation['tmsId'],
        show_id: show.id
      })
    end
  end

  def import_episodes(series_id, offset = 0)
    page_response = HTTParty.get("https://data.tmsapi.com/v1.1/series/#{series_id}/episodes?api_key=#{ENV['TMS_API_KEY']}&offset=#{offset}&titleLang=en&descriptionLang=en&imageSize=Ms&imageAspectTV=4x3&imageText=true")

    if page_response['errorCode']
      return # no more episodes
    end

    max_offset = page_response['hitCount']

    page_response['hits'].each do |episode|
      import_show(episode)
      offset += 1
    end

    unless offset >= max_offset
      import_episodes(series_id, offset)
    end
  end

  private

  def api_url(options)
    image_params = get_image_params(options[:tmsId])
    if options[:tmsId] || options[:rootId]
      "http://data.tmsapi.com/v1.1/programs/#{options[:tmsId] || options[:rootId]}?api_key=#{ENV['TMS_API_KEY']}&titleLang=en&descriptionLang=en&#{image_params}";
    else
      "http://data.tmsapi.com/v1.1/series/#{options[:seriesId]}?api_key=#{ENV['TMS_API_KEY']}&titleLang=en&descriptionLang=en&#{image_params}";
    end
  end

  # Use different parameters depending if it is a show or movie
  def get_image_params(tmsId = '')
    if tmsId&.starts_with?('MV')
      "imageSize=Ms&imageAspect=4x3&imageText=true"
    else
      "imageSize=Lg&imageAspectTV=4x3&imageText=true"
    end
  end
end
