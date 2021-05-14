class AddAwardsCountToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :awards_count, :integer, default: 0
  end
end
