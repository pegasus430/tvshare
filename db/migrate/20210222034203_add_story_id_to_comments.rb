class AddStoryIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :story_id, :integer
    add_index :comments, :story_id
  end
end
