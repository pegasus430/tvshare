class AddCountsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :comments_count, :integer
    add_column :users, :likes_count, :integer
    add_column :users, :followers_count, :integer
    add_column :users, :followed_users_count, :integer

    User.find_each do |user|
      User.reset_counters(user.id, :comments, :likes, :followers, :followed_users)
    end
  end
end
