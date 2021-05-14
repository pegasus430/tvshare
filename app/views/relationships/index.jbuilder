json.followers do
  json.array! @current_user.followers.pluck(:id)
end

json.followed_users do
  json.array! @current_user.followed_users.pluck(:id)
end
