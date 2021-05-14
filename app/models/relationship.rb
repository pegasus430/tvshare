class Relationship < ApplicationRecord
  belongs_to :followed_user, class_name: 'User', foreign_key: :followed_id, counter_cache: :followed_users_count, optional: true
  belongs_to :follower_user, class_name: 'User', foreign_key: :follower_id, counter_cache: :followers_count, optional: true
end
