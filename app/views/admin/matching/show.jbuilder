json.merge! @show.attributes
json.networks @show.networks_and_streaming_services.map(&:display_name)
json.display_genres GenreMap.find_display_genres(@show.genres)
