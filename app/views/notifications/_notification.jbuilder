json.extract! notification, :id, :message, :notifiable_type, :notifiable_id, :read_at
json.actor do
  json.username notification&.actor&.username
  json.image notification&.actor&.image
  json.bio notification&.actor&.bio
end
