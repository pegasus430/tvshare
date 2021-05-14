class AddVideosToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :videos, :text, array: true, default: []
    add_column :sub_comments, :videos, :text, array: true, default: []
  end
end
