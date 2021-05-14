@genre_shows.each do |genre, shows|
  json.set! genre do
    json.results do
      json.array! shows, :id, :title, :preferred_image_uri, :tmsId, :seriesId, :rootId, :formatted_networks
    end

    json.pagination do
      json.total_count shows.total_count
      json.next_page (genre_shows_genres_path(genre, page: 2, station_id: @station_id) unless shows.last_page?)
    end
  end
end
