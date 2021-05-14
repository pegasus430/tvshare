json.partial! partial: 'shared/pagination', records: @likes

json.results @likes.map(&:show) do |show|
  json.extract! show, :id, :tmsId, :title, :seasonNum, :episodeNum, :shares_count, :likes_count, :comments_count, :stories_count, :activity_count, :popularity_score, :shortDescription, :seriesId, :rootId, :preferred_image_uri, :episodeTitle
end
