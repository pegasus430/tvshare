json.partial! partial: 'shared/pagination', records: @sub_comments

json.results @sub_comments.each do |sub_comment|
  json.extract! sub_comment, :id, :text, :images, :videos, :created_at
  json.likes_count sub_comment.likes_count || 0
  json.sub_comments_count sub_comment.sub_comments_count || 0
  json.shares_count sub_comment.shares_count || 0
  json.created_at_formatted distance_of_time_in_words(sub_comment.created_at, Time.current)

  json.user do
    json.id sub_comment&.user&.id
    json.username sub_comment&.user&.username
    json.image sub_comment&.user&.image
  end
end
