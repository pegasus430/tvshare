class AllowNullCommentShowId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :comments, :show_id, :integer, null: true
  end
end
