class AllowNullSubCommentsCommentId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :sub_comments, :comment_id, :integer, null: true
  end
end
