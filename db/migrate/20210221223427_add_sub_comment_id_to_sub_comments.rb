class AddSubCommentIdToSubComments < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_comments, :sub_comment_id, :integer
    add_index :sub_comments, :sub_comment_id
  end
end
