class AddImportedNewsAtToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :imported_news_at, :datetime
    add_index :shows, :imported_news_at
  end
end
