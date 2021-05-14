class AddPopularityCountToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :popularity_score, :integer, default: 0
    add_index :shows, :popularity_score
  end
end
