class AddLikesToSub < ActiveRecord::Migration[6.0]
  def change
    add_reference :likes, :sub_comment, foreign_key: true
  end
end
