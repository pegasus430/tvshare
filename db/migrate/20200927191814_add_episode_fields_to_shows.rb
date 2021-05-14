class AddEpisodeFieldsToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :episodeTitle, :string
    add_column :shows, :episodeNum, :integer
    add_column :shows, :seasonNum, :integer
  end
end
