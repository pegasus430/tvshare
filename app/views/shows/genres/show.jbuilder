json.results @shows
json.genre @genre

json.pagination do
  json.page_size @shows.limit_value
  json.current_page @shows.current_page
  json.total_pages @shows.total_pages
  json.total_count @shows.total_count
  json.next_page genre_shows_genres_path(@genre, page: @shows.next_page, station_id: @station_id) unless @shows.last_page?
end
