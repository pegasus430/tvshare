class ImportImdbIdJob < ApplicationJob
  IMDB_HOST_ID = 79627 # Gracenote's ID for IMDB
  queue_as :default

  def perform(show)
    @show = show

    # Note: "Episodes" won't have an IMDB ID.
    if @show.tmsId.starts_with?('SH')
      import_series_imdb_id
    elsif @show.tmsId.starts_with?('MV')
      import_movie_imdb_id
    end
  end

  # Update series & episode records
  def import_series_imdb_id
    imdb_id = extract_imdb_id
    Show.where(seriesId: @show.seriesId).update_all(imdb_id: imdb_id)
  end

  def import_movie_imdb_id
    imdb_id = extract_imdb_id
    @show.update_attributes(imdb_id: imdb_id)
  end

  private

  # Finds the XML node relating to IMDB ID
  # Extracts the IMDB ID from the IMDB URL
  def extract_imdb_id
    doc = Nokogiri::XML(fetch_data.body)
    links = doc.xpath("//link")
    imdb_node = links.find do |link|
      link.at_xpath("host[@id=#{IMDB_HOST_ID}]")
    end

    if imdb_node
      imdb_link = imdb_node.at_xpath('url').text
      imdb_id = imdb_link.scan(/.*imdb.com\/title\/(.*)\//).flatten&.first
    end

    imdb_id
  end

  def fetch_data
    HTTParty.get(api_url)
  end

  def api_url
    "http://feeds.tmsapi.com/social/#{@show.tmsId}.xml?api_key=#{ENV['TMS_API_KEY']}"
  end
end
