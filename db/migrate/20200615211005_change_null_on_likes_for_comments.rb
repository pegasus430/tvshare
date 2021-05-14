class ChangeNullOnLikesForComments < ActiveRecord::Migration[6.0]
  def change
    change_column_null :likes, :comment_id, true
  end
end
