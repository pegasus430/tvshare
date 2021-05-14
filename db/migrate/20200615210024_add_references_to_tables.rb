class AddReferencesToTables < ActiveRecord::Migration[6.0]
  def change
    add_reference :likes, :show, foreign_key: true
    add_reference :comments, :show, null: false, foreign_key: true

  end
end
