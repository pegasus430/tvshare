class AddCountersToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :likes_count, :integer
    add_column :comments, :sub_comments_count, :integer

    Comment.find_each do |comment|
      Comment.reset_counters(comment.id, :likes)
      Comment.reset_counters(comment.id, :sub_comments)
    end
  end
end
