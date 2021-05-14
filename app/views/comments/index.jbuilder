json.partial! partial: 'shared/pagination', records: @comments

json.results do
  json.partial! 'comments/comment', collection: @comments, as: :comment
end
