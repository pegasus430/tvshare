json.extract! story, :id, :title, :description, :source, :image_url, :published_at, :url, :show_id, :shares_count
json.likes_count story.likes_count || 0
json.published_at_formatted distance_of_time_in_words(story.published_at || story.created_at, Time.current)
json.iframe_enabled story.story_source&.iframe_enabled

json.likes_count_by_followed_users @stories_likes_from_followed_users.present? ? (@stories_likes_from_followed_users[story.id] || 0) : 0
