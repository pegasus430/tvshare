class AddCountsToSubcomments < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_comments, :likes_count, :integer, default: 0
    add_column :sub_comments, :sub_comments_count, :integer, default: 0
  end
end
