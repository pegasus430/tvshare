class CreateShows < ActiveRecord::Migration[6.0]
  def change
    create_table :shows do |t|
      t.string :descriptionLang
      t.string :entityType
      t.text :longDescription
      t.text :officialUrl
      t.string :origAirDate
      t.string :releaseDate
      t.integer :releaseYear
      t.string :rootId
      t.string :runTime
      t.string :seriesId
      t.text :shortDescription
      t.string :subType
      t.string :title
      t.string :titleLang
      t.string :tmsId
      t.integer :totalEpisodes
      t.string :totalSeasons

      t.timestamps
    end
  end
end
