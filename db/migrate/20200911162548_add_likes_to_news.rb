class AddLikesToNews < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :story_id, :bigint
    add_column :stories, :likes_count, :bigint
  end
end
