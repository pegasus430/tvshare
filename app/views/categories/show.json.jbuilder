json.extract! @category, :id, :title
json.shows(@category.shows) do |show|
  json.extract! show, *%i(id title genres preferred_image_uri tmsId rootId popularity_score)
  json.callSign show.formatted_networks.compact.join(', ')
end
