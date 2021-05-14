json.extract! category, :id, :title, :active, :position, :created_at, :updated_at
json.url category_url(category, format: :json)

json.shows do
  json.array! category.show_categories.each do |show_category|
    json.position show_category.position
    json.extract! show_category.show, :id, :title, :preferred_image_uri, :tmsId, :seriesId, :rootId, :formatted_networks
   end
end
