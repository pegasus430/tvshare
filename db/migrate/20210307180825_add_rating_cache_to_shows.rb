class AddRatingCacheToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :rating_percentage_cache, :json, default: {}
  end
end
