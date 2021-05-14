class AddCompoundIndexForShows < ActiveRecord::Migration[6.0]
  def change
    add_index :shows, [:tmsId, :genres, :popularity_score]
  end
end
