class AddShowsSeriesIdIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :shows, :seriesId
  end
end
