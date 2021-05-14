class AddCommentsCountToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :comments_count, :integer
  end
end
