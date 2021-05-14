class ImportHuluOriginalsJob < ApplicationJob
  URL = 'https://www.hulu.com/sitemap/hulu-originals'
  queue_as :default

  def perform(*args)
    response = HTTParty.get(URL)
    doc = Nokogiri::HTML(response)

    doc.css('.ListCardItem__item a').each do |node|
      url = node.attributes['href'].text
      title = node.attributes['title'].text
      id = extract_id(url)
      entity_type = extract_entity_type(url)

      import_show({
        id: id,
        title: title,
        entityType: entity_type
      })
    end
  end

  def import_show(program)
    show = Show.find_or_initialize_by({
      original_streaming_network: :hulu,
      original_streaming_network_id: program[:id],
    })

    show.title = program[:title]
    show.entityType = program[:entityType]
    show.save if show.tmsId.blank? # if it's already been matched, don't update
  end

  def extract_id(string)
    # extracts the id from the video url
    # id format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    string.match(/(\w{8}-\w{4}-\w{4}-\w{4}-\w{12})/).to_s
  end

  def extract_entity_type(string)
    # extracts either "series" or "movie" from the video url
    string.match(/\/(series|movie)\//).to_a.last
  end
end
