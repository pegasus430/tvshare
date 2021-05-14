json.partial! partial: 'shared/pagination', records: @users

json.results @users do |user|
  json.extract! user, :id, :username, :image, :bio
end
