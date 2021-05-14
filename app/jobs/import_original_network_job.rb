class ImportOriginalNetworkJob < ApplicationJob
  queue_as :default

  def perform(show)
    @show = show
    import_networks if show.imdb_id
  end

  def import_networks
    response = fetch_data

    if response.success?
      data = JSON.parse(response.body)
      import_network(data) if data.dig('network', 'name')
      import_streaming_network(data) if data.dig('webChannel', 'name')
    else
      Rails.logger.warn "Network Importer: Error: Match via IMDB ID not found for show ##{@show.id} - #{@show.title} (#{@show.tmsId})"
    end
  end

  def import_network(data)
    external_network_name = data['network']['name']
    internal_network_name = Networks::TV_MAZE_MAP[external_network_name]

    if internal_network_name
      network = Network.find_by(display_name: internal_network_name)
      @show.networks << network unless @show.networks.include?(network)
      Rails.logger.info "Network Importer: Success Match via IMDB ID found for show ##{@show.id} - #{@show.title} (#{@show.tmsId}) on #{internal_network_name}"
    else
      Rails.logger.warn "Network Importer: Error: Network mapping for #{external_network_name} not found"
    end
  end

  def import_streaming_network(data)
    external_network_name = data.dig('webChannel', 'name')

    if external_network_name == 'Netflix'
      @show.netflix!
    elsif external_network_name == 'Hulu'
      @show.hulu!
    elsif external_network_name == 'Amazon Prime'
      @show.prime!
    end
  end

  private

  def fetch_data
    HTTParty.get(api_url)
  end

  def api_url
    "https://api.tvmaze.com/lookup/shows?imdb=#{@show.imdb_id}"
  end
end
