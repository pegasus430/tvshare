class AddNetworkAndEpisodeCounterCacheToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :networks_count, :bigint, default: 0
    add_column :shows, :episodes_count, :bigint, default: 0

    add_index :shows, :networks_count
    add_index :shows, :episodes_count
  end
end
