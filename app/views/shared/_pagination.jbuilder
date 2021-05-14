json.pagination do
  json.extract! records, :current_page, :total_pages, :prev_page, :next_page, :total_count, :current_per_page
end
