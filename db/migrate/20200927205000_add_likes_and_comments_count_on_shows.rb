class AddLikesAndCommentsCountOnShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :comments_count, :bigint, default: 0
    add_column :shows, :likes_count, :bigint, default: 0
    add_column :shows, :stories_count, :bigint, default: 0

    Show.find_each do |show|
      Show.reset_counters(show.id, :comments, :likes, :shares, :stories)
    end
  end
end
