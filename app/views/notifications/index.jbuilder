json.partial! partial: 'shared/pagination', records: @notifications

json.results do
  json.partial! 'notifications/notification', collection: @notifications, as: :notification
end
