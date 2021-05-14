class ImportNetflixOriginalsJob < ApplicationJob
  URL = 'https://media.netflix.com/gateway/v1/en/titles'
  queue_as :default

  def perform(*args)
    api_response = HTTParty.get(URL)
    api_response['items'].each do |program|
      import_show(program)
    end
  end

  def import_show(program)
    release_date = get_release_date(program['premiereDate'])

    show = Show.find_or_initialize_by({
      original_streaming_network: :netflix,
      original_streaming_network_id: program['id']
    })

    show.title = program['name']
    show.entityType = program['type']
    show.releaseDate = release_date
    show.releaseYear = release_date&.year
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end

  # Sometimes Netflix gives us "Upcoming" or "2020" as the release date.
  # This will return nil in those instances.
  def get_release_date(release_date)
    Date.parse(release_date)
  rescue ArgumentError
    nil
  end
end
