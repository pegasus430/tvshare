class AddImdbIdToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :imdb_id, :string
  end
end
