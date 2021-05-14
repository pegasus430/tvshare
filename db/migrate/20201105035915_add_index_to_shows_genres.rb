class AddIndexToShowsGenres < ActiveRecord::Migration[6.0]
  def change
    add_index :shows, :genres
  end
end
