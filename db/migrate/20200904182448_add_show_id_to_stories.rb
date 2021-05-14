class AddShowIdToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :show_id, :integer
    add_index :stories, :show_id
  end
end
